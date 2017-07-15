namespace OpenSage {
	public class Program {
		private static Engine engine;

		public static int main(string[] args){
			if (!Thread.supported ()) {
				stderr.printf ("Cannot run without thread support.\n");
				return 1;
			}
			
			engine = new Engine(new EngineSettings(args));
			return engine.run();
		}
	}
}
