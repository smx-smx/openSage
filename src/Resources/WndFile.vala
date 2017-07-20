using Gee;
using OpenSage.Resources.WndProperties;
namespace OpenSage.Resources {

public class WndTokens {
	public const char ASSIGN = '=';
	public const char EOS = ';'; //end of statement
	public const char KEY_SETVAL = ':';
	public const char ARRAY_NEXT_EL = ',';

	public static bool isToken(char ch){
		return ch == ASSIGN || ch == EOS || ch == KEY_SETVAL || ch == ARRAY_NEXT_EL;
	}
}

public class WndProperty<T> {
	public T Value;
}

public class WndSection {
	public string StartItem;
	public string EndItem;
	public HashMap<string, WndProperty?> Items = new HashMap<string, WndProperty?> ();
	
	public delegate void SectionInitializer(WndSection section);

	public WndSection(string start, string end, SectionInitializer? init){
		StartItem = start;
		EndItem = end;
		if(init != null){
			init(this);
		}
	}

	public WndProperty get (string name) {
        return Items[name];
    }

    public void set (string name, WndProperty prop) {
        Items[name] = prop;
    }
}

public class WndSections {
	public static HashMap<string, WndSection?> Sections = new HashMap<string, WndSection?> ();

	private static void addSection(string start, string end, WndSection.SectionInitializer? init){
		stdout.printf("=> Adding %s\n", start);
		Sections.set(start, new WndSection(start, end, init));
	}

	public static WndSections() {
		stdout.printf("=> INIT\n");
		addSection("STARTLAYOUTBLOCK", "ENDLAYOUTBLOCK", initLayoutBlock);
		addSection("WINDOW", "END", initWindowBlock);
	}

	private static void initLayoutBlock(WndSection s){
		//append the possible fields
		s["LAYOUTINIT"] = new WndProperty<string>();
		s["LAYOUTUPDATE"] = new WndProperty<string>();
		s["LAYOUTSHUTDOWN"] = new WndProperty<string>();
	}

	private static void initWindowBlock(WndSection s){
		s["WINDOWTYPE"] = new WndProperty<string>();
		s["SCREENRECT"] = new WndProperty<string>();
	}

	public static WndSection get(string name) {
        return Sections[name];
    }

}

public class WndConstants {
	const string FILE_VERSION = "FILE_VERSION";
	//const string LAYOUT_BLOCK =	
}

public class LayoutBlock {
	public const string INIT = "LAYOUTINIT";
	public const string UPDATE = "LAYOUTUPDATE";
	public const string SHUTDOWN = "LAYOUTSHUTDOWN";

	public const string START = "STARTLAYOUTBLOCK";
	public const string END = "ENDLAYOUTBLOCK";

	private string init;
	private string update;
	private string shutdown;

	public static bool is_valid(string token){
		return token == START;
	}

	public LayoutBlock(WndFile wnd){
		wnd.readLine(); //consume start
		string token = null;
		do {
			string[] pair = wnd.nextAssignment();
			switch(pair[0]){
				case INIT:
					this.init = pair[0];
					break;
				case UPDATE:
					this.update = pair[0];
					break;
				case SHUTDOWN:
					this.shutdown = pair[0];
					break;
				default:
					stderr.printf("Unknown Layout type '%s'\n", pair[0]);
					break;
			}
		} while(token != END);
	}
}

public class WndFile {
	public const int VERSION = 2;
	private const char SEPARATOR = ';';

	private static WndSections Sections = new WndSections();

	private WndSection? currentSection;

	public int offset = 0;
	private unowned string data;

	private bool childrenAllowed = true;

	private string readToChar(char ch){
		int end_offset = data.index_of_char(ch, offset);
		string substr = data.substring(offset, end_offset - offset);
		offset = end_offset + 1;
		return substr;
	}

	private void readAfter(char ch){
		//while(data[offset++] != ch);
		int end_offset = data.index_of_char(ch, offset);
		offset = end_offset + 1;
	}

	public string readAssignment(){
		return readToChar(WndTokens.EOS);
	}

	public string readLine(){
		return readToChar('\n');
	}

	public string[]? parseAssignment(string stmt){
		int equalSign = stmt.index_of_char('=');
		if(equalSign < 0)
			return null;
		
		string left = stmt.substring(0, equalSign).strip();
		string right = stmt.substring(equalSign + 1).strip();

		string[] parts = new string[]{ left, right };
		return parts;
	}

	public string[] nextAssignment(){
		return parseAssignment(readAssignment());
	}

	// Consume the rest of the attributes/section name
	private string[] readSectionBlock(){
		string[] components = new string[]{};
		string line = null;
		int prevOffset = offset;
		while(true){
			line = readLine().strip();
			if(WndTokens.isToken(line[line.length - 1])){
				offset = prevOffset;
				return (components.length == 0) ? null : components;
			}
			prevOffset = offset;
			components += line;
		}
	}

	private string readMultiLineAssignment(string line){
		string ret = line;
		while(true){
			string rline = readLine().strip();
			ret += rline;
			if(rline[rline.length - 1] == WndTokens.EOS){
				return ret;
			}
		}
	}

	private bool processBlock(owned string line){
		line = line.strip();
		char last = line[line.length - 1];
		if(WndTokens.isToken(last)){
			switch(last){
				//example: characters;
				case WndTokens.EOS:
					string[] ass = parseAssignment(line);
					if(ass == null){
						stderr.printf("Couldn't parse assignment '%s'\n", line);
						return false;
					}
					stdout.printf("[ASSIGN] %s = %s\n", ass[0], ass[1]);
					return true;
				//example: characters,
				case WndTokens.ARRAY_NEXT_EL:
					string assignment = readMultiLineAssignment(line);
					if(!processBlock(assignment))
						return false;
					return true;
			}
		// example: ENDLAYOUTBLOCK
		} else if(currentSection != null && currentSection.EndItem == line){
			stdout.printf("[%s END]\n\n", currentSection.StartItem);
			return true;
		} else if(
			/* When a CHILD is defined, ENDALLCHILDREN is used to mark the end of all CHILDren.
			 * For now, i'm just gonna detect if this is specified inside a WINDOW section.
			 * Later on, an error can be thrown if a CHILD is declared after this
			 */
			currentSection != null &&
			currentSection.StartItem == "WINDOW" &&
			line == "ENDALLCHILDREN"
		){
			childrenAllowed = false;
			return true;
		} else {
			// Consume attributes
			string[]? sectionRest = readSectionBlock();
			
			string[] sectionAttributes = null;

			string sectionName = null;
			if(sectionRest != null){
				sectionAttributes = new string[]{line};
				for(int i=0; i<sectionRest.length - 1; i++){
					sectionAttributes += sectionRest[i];
				}
				sectionName = sectionRest[sectionRest.length - 1];
			} else {
				sectionName = line;
			}

			// Create a new section
			WndSection section = Sections[sectionName];
			if(section == null){
				stdout.printf("Section '%s' not found\n", sectionName);
				return false;
			}
			stdout.printf("[SECTION] %s\n", section.StartItem);
			if(sectionAttributes != null){
				foreach(string attr in sectionAttributes){
					stdout.printf("  [ATTR] %s\n", attr);
				}
			}
			currentSection = section;
		}
		return true;
	}

	private void consumeNewlines(){
		readAfter('\n');
	}

	private void loadFile(){	
		string[] versionAss = nextAssignment();
		if(versionAss[0] != "FILE_VERSION"){
			stderr.printf("Not a valid WND file\n");
			return;
		}
		int version = int.parse(versionAss[1]);
		if(version != 2){
			stderr.printf("Unsupported version %d\n", version);
			return;
		}
		consumeNewlines();
		
		while(offset < data.length){
			string line = readLine();
			if(!processBlock(line))
				break;
		}
	}

	public WndFile(string data){
		this.data = data;
		this.loadFile();
	}
	
	~WndFile(){

	}
}

}
