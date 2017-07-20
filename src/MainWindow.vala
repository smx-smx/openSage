using GL;
using GLU;
using GLEW;

using SDL;

using OpenSage.Loaders;

namespace OpenSage {
	public class MainWindow {
		GlewDummy *dummy;

		private Video.Window window;
		private Video.GL.Context context;

		private EngineSettings settings;
		
		private AsyncQueue<Texture?> TextureQueue = new AsyncQueue<Texture?>();
		private GLEventHandler ghandler = new GLEventHandler();
		
		public MainWindow(EngineSettings settings){
			this.settings = settings;
			if(!this.create()){
				this.terminate();
			}
			
			ghandler.onFrameStart.connect(clear);
			ghandler.onFrameEnd.connect(swap);
		}
		
		private void clear(){
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		}
		
		private void swap(){
			Video.GL.swap_window(this.window);
		}
		
		/* This function gets called by a thread that is sending a texture to us
		 * We can't render here, so we enqueue this texture for the main thread
		 * */
		private void onTexture(int width, int height, void *data){			
			Texture texture = Texture();
			texture.width = width;
			texture.height = height;
			texture.data = data;
			
			TextureQueue.push(texture);
		}
		
		private static void on_debug_message(
			GLenum source, GLenum type, GLuint id,
			GLenum severity, GLsizei length, string message, void* userParam
		){
			stdout.printf("[OPENGL] %s\n", message);
		}

		private void setAttributes(){
			//TODO: Switch to OpenGL CORE
		}
		
		private bool create(){
			if(SDL.init(
				SDL.InitFlag.VIDEO |
				SDL.InitFlag.AUDIO |
				SDL.InitFlag.TIMER |
				SDL.InitFlag.EVENTS
			) < 0){
				stderr.printf("SDL init failed: %s\n", SDL.get_error());
				return false;
			}
			//GLFW.WindowHint.OPENGL_DEBUG_CONTEXT.set_bool(true);
			this.window = new Video.Window(
				"openSage",
				Video.Window.POS_CENTERED,
				Video.Window.POS_CENTERED,
				this.settings.ScreenWidth,
				this.settings.ScreenHeight,
				Video.WindowFlags.OPENGL
			);
					
			if(this.window == null){
				stderr.printf("Cannot create SDL2 Window\n");
				return false;
			}

			this.context = Video.GL.Context.create(this.window);
			Video.GL.make_current(this.window, this.context);

			// Init GLEW after GLFW
			GLEW.glewInit();
			
			glEnable(GL_DEBUG_OUTPUT);
			glDebugMessageCallback((GLDEBUGPROC)on_debug_message, null);
			
			glViewport(0, 0, this.settings.ScreenWidth, this.settings.ScreenHeight);
			
			return true;
		}

		private void terminate(){
			SDL.quit();
		}
	
		public void MainLoop(){
			bool result;
			bool run = true;

			Handler handler = new Handler();
			handler.SwitchState(GameState.SPLASH);
			result = handler.load(settings.RootDir + "/Install_Final.bmp");
			if(!result){
				stderr.printf("Failed to open BMP\n");
				run = false;
			}
			
			// Right now, this is for ImageLoader (which isn't multithreaded)
			handler.onFrameStart.connect(clear);
			handler.onFrameEnd.connect(swap);
			
			handler.update(); // Show Splash Screen
			
			while(run){			
				/* Do we have any texture to render? */
				Texture? texture = TextureQueue.try_pop();
				if(texture != null){
					ghandler.RenderTexture2D(texture.width, texture.height, texture.data);
					delete texture.data; //done rendering, free the buffer
				} else {
					// Nothing to do, wait a bit
					SDL.Timer.delay(1);
				}
				
				if(handler.State == GameState.SPLASH){
					stdout.printf("Showing the splash for a few seconds...\n");
					//Posix.sleep(2);
					
					stdout.printf("Playing intro video...\n");
					handler.SwitchState(GameState.CINEMATIC);
					result = handler.load(settings.RootDir + "/Data/English/Movies/EA_LOGO.BIK");
					
					handler.onTextureReady.connect(onTexture);
					
					if(!result){
						stderr.printf("Failed to load EA_LOGO.bik\n");
						run = false;
					}
				}
				
				SDL.Event ev;
				SDL.Event.poll(out ev);
				
				if(ev.type == SDL.EventType.QUIT){
					run = false;
				}
				if(ev.type == SDL.EventType.KEYDOWN){
					stdout.printf("%s PRESSED!\n", ev.key.keysym.sym.get_name());
					if(ev.key.keysym.sym == Input.Keycode.ESCAPE)
						run = false;
				}
				
				stdout.flush();
			}
			
			this.terminate();
		}
	}
}
