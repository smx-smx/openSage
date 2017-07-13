namespace OpenSage {
	public class EngineSettings {
		public int ScreenWidth = 800;
		public int ScreenHeight = 600;
		public string RootDir = ".";
		
		const string OPTSTRING = "r:";
		
		public EngineSettings(string[] args){
			int c;
			while((c = Posix.getopt(args, EngineSettings.OPTSTRING)) > 0){
				switch(c){
					case 'r':
						RootDir = Posix.optarg;
						stdout.printf("RootDir: %s\n", RootDir);
						break;
				}
			}
		}
	}
}
