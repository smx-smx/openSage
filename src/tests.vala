/*
 * These are *NOT* unit tests (for now), but merely test snippets/functions
 */
using OpenSage.Loaders;
namespace OpenSage {
	public class Tests {
		public static void TestBigLoader(EngineSettings settings){
			BigLoader b = new BigLoader();
			bool result = b.load(settings.RootDir + "/INIZH.big");
			if(!result){
				stderr.printf("Failed to load BIG file\n");
			} else {
				uint8[]? data = b.getFile("data/ini/object/system.ini");
				if(data != null)
					stdout.puts((string)data);
			}
		}
	}
}