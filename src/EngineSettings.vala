namespace OpenSage {
	public class EngineSettings {
		public static int ScreenWidth = 800;
		public static int ScreenHeight = 600;
		public static string RootDir = ".";
		
		const string OPTSTRING = "d:r:";
		
		public EngineSettings(string[] args){
			int c;
			while((c = Posix.getopt(args, EngineSettings.OPTSTRING)) > 0){
				switch(c){
					// Debug Step
					case 'd':
						string debugger = Posix.optarg.down();
						switch(debugger){
							#if MINGW
							case "mgw":
								MingwExceptionHandler.init();
								break;
							case "vs":
								Win32.LaunchDebugger();
								//Win32.DebugBreak();
								break;
							#endif
								
						}
						break;
					// RootDir
					case 'r':
						RootDir = Posix.optarg;
						stdout.printf("RootDir: %s\n", RootDir);
						break;
				}
			}
		}
	}
}
