namespace OpenSage {
	public class Engine {
		public static OpenSage.Loaders.BigLoader BigLoader = new OpenSage.Loaders.BigLoader();
		public static EngineSettings Settings;
		private MainWindow window;

		public Engine(EngineSettings settings){
			Settings = settings;

			this.window = new MainWindow();
			this.window.MainLoop();
		}
		
		public int run(){
			return 0;
		}
	}
}
