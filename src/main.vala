namespace OpenSage {
	public class Program {
		private static Engine engine;
		
		public static int main(string[] args){
			engine = new Engine(new EngineSettings(args));
			return engine.run();
		}
	}
}
