using MFile;
using Gee;

namespace OpenSage.Tools.IniParser {
	public uintptr ptrdiff(void *a, void *b){
		return (uintptr)a - (uintptr)b;
	}

	public class IniTokens {
		public const char COMMENT = ';';
		public const char PREPROCESSOR = '#';
		public const char ASSIGNMENT = '=';
	}

	[SimpleType, IntegerType, CCode(has_type_id = "false")]
	public struct Percentage {
	}

	public struct MemString {
		public char *loc;
		public int size;

		public void ltrim(){
			int i = 0;
			int pre_size = size;
			for(
				;
				i<pre_size && (
					*loc == ' ' ||
					*loc == '\t'
				);
				i++, loc++, size--
			);
		}

		public string print_fmt(){
			var builder = new StringBuilder ();
			builder.append_printf("%.*s", size, loc);
			return builder.str;
		}

		public void rtrim(){
			for(
				int i = size - 1;
				size > 0 && (
					loc[i] == ' ' ||
					loc[i] == '\t'
				);
				i--, size--
			);
		}

		public void trim(){
			rtrim();			
			ltrim();
		}

		public int strlen_nonl(){
			//leftover from the previous trimming, which is now done previously
			return size;
		}

		public int index_of_char(char ch, int offset=0){
			char *start = loc + offset;
			for(int i=0; i<size - offset; i++){
				if(start[i] == ch)
					return i + offset;
			}
			return -1;
		}

		public string slice(int from, int to){
			int size = to - from;
			string str = (string)new char[size + 1];
			Memory.copy(str, &loc[from], size);
			str.data[size] = 0x00;
			//stdout.printf("Sliced: %s\n", str);
			return str;
		}

		public unowned char[] buf {
			get {
				unowned char[] chars = (char[])loc;
				chars.length = (int)size;
				return chars;
			}
		}
	}

	public struct IniDefine {
		public MemString Name;
		public MemString Data;
	}

	public class IniProperty<T> {
		public T Value;
		public IniProperty(T? value = null){
			Value = value;
		}
	}

	public class IniObject {
		public MemString? TypeName;
		public MemString Name;
		public HashMap<MemString?, IniProperty?> Properties = new HashMap<MemString?, IniProperty?>();
		public HashMap<MemString?, IniObject *> SubObjects = new HashMap<MemString?, IniObject*>();

		public IniObject(MemString? type_name, MemString obj_name){
			TypeName = type_name;
			Name = obj_name;
		}
	}

	public class IniFile {
		public MFILE *mf;
		public unowned string data;
		private int data_length;

		public IniObject *curObject = null;
		public bool in_subobj = false;
		public int cur_offset = 0;
		public int offset = 0;
	
		private string basedir;
		public Parser parser;

		public IniFile(
			MFILE *mf,
			Parser parser
		){
			this.parser = parser;
			this.mf = mf;

			unowned uint8[] buf = (uint8[])mf->data();
			buf.length = (int)mf->size();
			
			this.data = (string)buf;
			this.data_length = buf.length;

			this.basedir = Path.get_dirname(mf->path());
		}

		public string readToChar(char ch){
			int end_offset = data.index_of_char(ch, offset);
			string substr = data.substring(offset, end_offset - offset);
			offset = end_offset + 1;
			return substr;
		}
	
		public void readAfter(IniFile f, char ch){
			//while(data[offset++] != ch);
			int end_offset = data.index_of_char(ch, offset);
			offset = end_offset + 1;
		}
	
		public MemString readLine(){
			// Skip newlines directly
			int end_offset = data.index_of_char('\n', offset);
			if(end_offset < 0)
				end_offset = data_length;

			bool has_cr = data.data[end_offset - 1] == '\r';
			if(has_cr){
				end_offset--;
			}

			MemString str =
				{
					(char *)&data.data[offset],
					end_offset - offset
				};
			offset = end_offset + 1;
			if(has_cr)
				offset++;
			return str;
		}

		public bool processPreproc(
			MemString line,
			int offset = 0
		){
			int next_space = line.index_of_char(' ');
			//#[define....]
			string preproc_func = line.slice(offset + 1, next_space).down();
			int length_nonl = line.strlen_nonl();
			switch(preproc_func){
				case "define":
					//#define [xxx] [yyy]
					//     next   def
					int def_name_s = next_space + 1;
					//stdout.printf("%.*s\n", line.size, line.loc);
					int def_name_e = line.index_of_char(' ', def_name_s);
					int def_data_s = def_name_e + 1;
					int def_data_e = length_nonl;

					//TODO: We're assuming ASCII here
					//Make proper calls to is_ascii and to_ascii

					MemString defname =
					{
						(char *)&data.data[def_name_s],
						def_name_e - def_name_s
					};

					MemString defdata =
					{
						(char *)&data.data[def_data_s],
						def_data_e - def_data_s
					};

					stdout.printf("'%-25s' ==> '%.*s'\n",
						defname.print_fmt(),
						defdata.print_fmt()
					);

					parser.defines[defname] = defdata;
					return true;
				case "include":
					// We want to skip the " characters too
					int file_name_s = next_space + 2;
					int file_name_e = length_nonl - 1;
					
					string filename = line.slice(file_name_s, file_name_e);
					stdout.printf("INCLUDE %s\n", filename);
					
					parser.load_file(basedir + "/" + filename);
					parser.parse();
					return true;
				default:
					stderr.printf("Unhandled preprocessor function '%s'\n", preproc_func);
					return false;
			}
		}

		private bool processPropertyArray(MemString key, MemString[] values){
			IniProperty? prop = null;

			bool existing = curObject->Properties.has_key(key);
			
			if(existing)
				prop = curObject->Properties[key];

			foreach(MemString val in values){
				if(is_double(val)){
					if(!existing){
						prop = new IniProperty<ArrayList<double?>>(
							new ArrayList<double?>()
						);
					}
					double num = double.parse((string)val.loc);
					
					((IniProperty<ArrayList<double?>>)prop).Value.add(num);
				} else {
					if(!existing){
						prop = new IniProperty<ArrayList<string>>(
							new ArrayList<string>()
						);
					}
					((IniProperty<ArrayList<MemString?>>)prop).Value.add(val);
				}
			}
			
			if(prop == null){
				stderr.printf("Failed to process array assignment at %u\n", cur_offset);
				return false;
			}

			if(!existing)
				objAddProperty(key, prop);
			return true;
		}

		private bool processPropertyValue(MemString key, MemString value){		
			IniProperty? prop = null;
			
			int tok_pos = -1;
			if(is_double(value)){
				var p = new IniProperty<double?>(double.parse((string)value.loc));
				prop = p;
				return true;
			} else if(is_percentage(value, out tok_pos)){
				//TODO: Vala breaks when using SimpleType structs as generic types
				//This should use a Percentage type since it's not a normal integer
				int pvalue = int.parse(value.slice(0, tok_pos));
				var p = new IniProperty<int>(pvalue);
				prop = p;
			} else if(is_macro(value)){
				var p = new IniProperty<MemString?>(parser.defines[value]);
				prop = p;
			} else {
				var p = new IniProperty<MemString?>(value);
				prop = p;
			}

			if(prop == null){
				stderr.printf("Failed to process assignment at %u\n", cur_offset);
				return false;
			}

			objAddProperty(key, prop);
			return true;
		}

		private bool processObject(MemString line, int offset = 0, bool isSubObject = false){
			int length_nonl = line.strlen_nonl();
			/*int next_space = line.slice(0, length_nonl)
				.replace("\t", " ")
				.index_of_char(' ');*/
			
			int next_space = line.index_of_char(' ');
			//stdout.printf("%s\n", line.print_fmt());

			/*
			 * Some objects don't have a name
			 * We assume they are global objects if that's the case
			 * */
			bool isGlobal = next_space < 0;

			MemString? type_name = null;
			MemString? obj_name = null;

			if(isSubObject || isGlobal){
				int obj_name_s = (int)ptrdiff(line.loc, data.data) + offset;
				int obj_name_e = length_nonl;

				obj_name =
				{
					(char *)&data.data[obj_name_s],
					obj_name_e - offset
				};
			} else {
				int type_name_s = (int)ptrdiff(line.loc, data.data) + offset;
				int type_name_e = next_space;

				type_name =
				{
					(char *)&data.data[type_name_s],
					type_name_e - offset
				};

				int obj_name_s  = (int)ptrdiff(line.loc, data.data) + next_space + 1;
				int obj_name_e  = length_nonl;
	
				obj_name =
				{
					(char *)&data.data[obj_name_s],
					obj_name_e - (next_space + 1)
				};
			}

			if(obj_name != null){
				obj_name.trim();
			}
			if(type_name != null){
				type_name.trim();
			}

			if(!isSubObject){
				/*stdout.printf("[%s:%u] %s<%s>\n",
					mf->path(),
					cur_offset,
					obj_name.print_fmt(),
					type_name.print_fmt()
				);*/
				if(parser.types.contains(type_name))
					parser.types.add(type_name);
			}

			IniObject *obj = new IniObject(type_name, obj_name);
			
			if(isSubObject){
				objAddObject(obj_name, obj);
			} else {
				parser.objects[obj_name] = obj;
				curObject = obj;
			}
			return true;
		}

		private bool is_double(MemString str, out int? index = null){
			index = str.index_of_char('.'); 
			return index > -1;
		}
		private bool is_percentage(MemString str, out int? index = null){
			index = str.index_of_char('%'); 
			return index > -1;
		}
		private bool is_macro(MemString str){
			return parser.defines.has_key(str);
		}

		private bool objAddProperty(MemString? key, IniProperty prop){
			assert(curObject != null);

			if(curObject->Properties.has_key(key)){
				stderr.printf("Error: redefining %s\n", key.print_fmt());
				return false;
			}

			curObject->Properties[key] = prop;
			return true;
		}

		private bool objAddObject(MemString? key, IniObject *obj){
			assert(curObject != null);

			if(curObject->SubObjects.has_key(key)){
				stderr.printf("Error: redefining %s\n", key.print_fmt());
				return false;
			}

			curObject->SubObjects[key] = obj;
			return true;
		}

		public int parse(){
			while(offset < data_length){
				MemString line = readLine();
				line.trim();
				if(!processLine(line))
					break;
			
				cur_offset = offset;
			}
			return 0;
		}

		private bool processLine(MemString line){
			// Empty Line
			if(line.size == 0){
				return true;
			}
			
			int comment_pos = line.index_of_char(IniTokens.COMMENT);
			/* Skip line if it contains only a comment */
			if(comment_pos == 0){
				//stdout.printf("[SKIP] %.*s\n", line.size, line.loc);
				return true;
			}

			if(comment_pos >= 0){
				//line = line.slice(0, comment_pos);
				line.size -= line.size - comment_pos + 1;

				if(line.size == 0)
					return true;
			}

			//stdout.printf("[LINE] %.*s\n", line.size, line.loc);

			int preproc_pos = line.index_of_char(IniTokens.PREPROCESSOR);
			/*
			 * Only handle preprocessor macros if they are the
			 * only thing in the line
			 * */
			if(preproc_pos == 0){
				return processPreproc(line, preproc_pos);
			}/* else if(preproc_pos > leading_spaces){
				stderr.printf("Mixed preprocessor macros and statements not allowed\n");
				return false;
			}*/

			if(curObject != null){
				int ass_pos = line.index_of_char(IniTokens.ASSIGNMENT);
				if(ass_pos > -1){
					if(ass_pos >= 0){
						return processAssignment(line, 0, ass_pos);
					}
				} else if(line.size >= 3){
					// Check for end
					string end = line.slice(0, 3).down();

					if(end == "end"){
						if(in_subobj)
							in_subobj = false;
						else
							curObject = null;
						return true;
					} else {
						//if(in_subobj){
							

							//stderr.printf("Nested SubObjects not supported - at [%u]\n", cur_offset);
							//return false;
						//}

						/*
						 * Subobjects only have a name without type, so enter the subobject only
						 * when there's no space in the line
						 */
						int space_pos = line.index_of_char(' ');
						if(space_pos < 0){
							//stdout.printf("Enter subobject at %s\n", line.print_fmt());
							//SubObject (Nuggets)
							in_subobj = true;
							return processObject(line, 0, true);
						}

						/*
						 * If we got here, it means that this is not a subobject,
						 * but an assignment without '=' sign, e.g
						 * ScreenCreationRes X:800 Y:600
						 * We treat this as an assignment similar to
						 * ScreenCreationRes = X:800 Y:600
						 */
						return processAssignment(line, 0, space_pos);
					}
				}
			}

			//stdout.printf("Line: %lu - %.*s\n", line.size, line.size, line.loc);
			return processObject(line, 0);
		}

		private bool processAssignment(
			MemString line,
			int k_off = 0, //offset of the key relative to the line
			int tok_off	   //offset of the assignment operator (can be '=' or ' ' for 'fake' subobjects)
		){
			MemString key = {
				(char *)&data.data[ptrdiff(line.loc, data.data) + k_off],
				tok_off - k_off
			};
			key.trim();

			
			int length_nonl = line.strlen_nonl();
			int vals_s = (int)ptrdiff(line.loc, data.data) + tok_off + 1;

			MemString vals = {
				(char *)&data.data[vals_s],
				length_nonl - (tok_off + 1)
			};
			vals.trim();

			//stdout.printf("%s <= %s\n", key.print_fmt(), vals.print_fmt());

			MemString[] val_locs = {};

			int next_space = -1;
			int vals_off = 0;
			while(true){
				next_space = vals.index_of_char(' ', vals_off);
				if(next_space < 0)
					break;
				
				int val_s = (int)ptrdiff(vals.loc, data.data) + vals_off;
				int val_e = (int)ptrdiff(vals.loc, data.data) + next_space;

				MemString val = {
					(char *)&data.data[val_s],
					val_e - val_s
				};

				vals_off = next_space + 1;

				val_locs += val;
			}

			// INI files can have multiple assignments with the same key
			// Since we can't know at this point (unless we lookahead)
			// We're gonna treat everything as an array, even 1 sized ones
			// TODO: alternatives?
			#if false
			bool is_array = val_locs.length > 1;
			#else
			bool is_array = val_locs.length > 0;
			#endif

			if(is_array){
				return processPropertyArray(key, val_locs);
			} else if(val_locs.length > 0) {
				return processPropertyValue(key, val_locs[0]);
			} else {
				// Values can be empty
				MemString empty = {(char *)null, 0};
				return processPropertyValue(key, empty);
			}


			stderr.printf("Error: Object %s has no properties\n", curObject->Name.print_fmt());
			return false;
		}
	}

	public class Parser {
		private ArrayQueue<IniFile*> files = new ArrayQueue<IniFile*>();

		public static Parser from_file(string path){
			MFILE *mf = MFILE.open(path, Posix.O_RDONLY);
			return new Parser(mf);
		}

		public void load_file(string path){
			MFILE *mf = MFILE.open(path, Posix.O_RDONLY);
			IniFile *f = new IniFile(mf, this);
			files.offer(f);
		}

		public HashMap<MemString?, MemString?> defines = new HashMap<MemString?, MemString?>();
		public HashSet<MemString?> types = new HashSet<MemString?>();

		private IniObject* curObject = null;
		public HashMap<MemString?, IniObject*> objects = new HashMap<MemString?, IniObject*>();

		public Parser(MFILE *mf){
			IniFile *f = new IniFile(
				mf,
				this
			);
			files.offer(f);
		}

		public void parse(){
			IniFile *f = files.poll();
			f->parse();
		}

		~Parser(){
			int nFiles = files.size;
			for(int i=0; i<nFiles; i++){
				IniFile *f = files.poll();
				if(f != null){
					if(f->mf != null)
						delete f->mf;
					delete f;
				}
			}
		}

	}

	public class Program {
		public static int main(string[] args){
			Posix.setvbuf(Posix.stdout, null, Posix.BufferMode.Unbuffered, 0);
			Posix.setvbuf(Posix.stderr, null, Posix.BufferMode.Unbuffered, 0);
			if(args.length < 2){
				stderr.printf("Usage: %s [file.ini]\n", args[0]);
				return 1;
			}
			string filename = args[1];
			stdout.printf("=> Parsing %s\n", filename);
			Parser p = Parser.from_file(filename);
			p.parse();
			return 0;
		}
	}
}