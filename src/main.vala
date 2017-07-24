namespace OpenSage {
	public class Program {
		private static Engine engine;

		public static int main(string[] args){
			// Disable stdout/stderr buffering
			Posix.setvbuf(Posix.stdout, null, Posix.BufferMode.Unbuffered, 0);
			Posix.setvbuf(Posix.stderr, null, Posix.BufferMode.Unbuffered, 0);

			#if MINGW
			MingwExceptionHandler.init();
			#endif
		
			if (!Thread.supported ()) {
				stderr.printf ("Cannot run without thread support.\n");
				return 1;
			}
			
			engine = new Engine(new EngineSettings(args));
			return engine.run();
		}
	}
}
