namespace OpenSage {
	public class Engine {
		private EngineSettings settings;
		private MainWindow window;
		
		public Engine(EngineSettings settings){
			this.settings = settings;
			this.window = new MainWindow(this.settings);
			
			this.window.MainLoop();
		}
		
		public int run(){
			return 0;
		}
	}
}
