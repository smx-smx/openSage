using GL;
using GLU;
using GLEW;

using SDL;

using OpenSage.Loaders;
using OpenSage.Resources;
using OpenSage;

using MFile;

namespace OpenSage {
	public class MainWindow {
		public static OpenSage.Handler Handler = new OpenSage.Handler();

		GlewDummy *dummy;

		private Video.Window window;
		private Video.GL.Context context;
	
		private AsyncQueue<Texture?> TextureQueue = new AsyncQueue<Texture?>();
		private GLEventHandler ghandler = new GLEventHandler();
		
		public MainWindow(){
			if(!this.create()){
				this.terminate();
			}
			
			ghandler.onFrameStart.connect(clear);
			ghandler.onFrameEnd.connect(swap);
		}
		
		private void clear(){
			if(Handler.State == GameState.INGAME){
				glDepthMask((GLboolean)GL_TRUE);
			}
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
			if(Handler.State == GameState.INGAME){
				glColor4f (0.0f, 0.0f, 0.0f, 0.00f);
			}
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
				Engine.Settings.ScreenWidth,
				Engine.Settings.ScreenHeight,
				Video.WindowFlags.OPENGL
			);
					
			if(this.window == null){
				stderr.printf("Cannot create SDL2 Window\n");
				return false;
			}
			Video.GL.set_attribute(Video.GL.Attributes.CONTEXT_FLAGS, Video.GL.ContextFlag.DEBUG);
			
			this.context = Video.GL.Context.create(this.window);
			Video.GL.make_current(this.window, this.context);

			// Init GLEW after GLFW
			GLEW.glewExperimental = GL_TRUE;
			GLEW.glewInit();
			
			glEnable(GL_DEBUG_OUTPUT);
			glDebugMessageCallback((GLDEBUGPROC)on_debug_message, null);
			
			glEnable (GL_DEPTH_TEST);
			glViewport(0, 0, Engine.Settings.ScreenWidth, Engine.Settings.ScreenHeight);
			
			return true;
		}

		private void terminate(){
			SDL.quit();
		}
	
		private MFILE model;

		private void test_model(){
			if(
				// Load ZH Models and Textures
				!Engine.BigLoader.load(Engine.Settings.RootDir + "/W3DZH.big") ||
				!Engine.BigLoader.load(Engine.Settings.RootDir + "/TexturesZH.big") ||
				// Load Generals Models and Textures (TODO: assuming path)
				!Engine.BigLoader.load(Engine.Settings.RootDir + "/../Command and Conquer Generals/W3D.big") ||
				!Engine.BigLoader.load(Engine.Settings.RootDir + "/../Command and Conquer Generals/Textures.big")
			){
				stderr.printf("Failed to load BIG file\n");
			}

			unowned uint8[]? data = Engine.BigLoader.getFile("art/w3d/avpaladin.w3d");
			if(data == null){
				stderr.printf("Cannot load model data\n");
				return;
			}
			//model = MFILE.open(EngineSettings.RootDir + "/avPaladin.W3D", Posix.O_RDONLY);
			//model = MFILE.open(EngineSettings.RootDir + "/12ABLT.W3D", Posix.O_RDONLY);
			//uint8* data = model.data();

			unowned uint8[] buf = (uint8[])data;
			//buf.length = (int)model.size();

			if(data != null){
				var m = new W3D.Model(buf);
				var r = new W3D.Renderer.ModelRenderer(m);
			}
		}

		private static bool SKIP_INTRO_TEST = true;

		public void MainLoop(){
			bool result;
			bool run = true;

			// Right now, this is for ImageLoader (which isn't multithreaded)
			Handler.onFrameStart.connect(clear);
			Handler.onFrameEnd.connect(swap);
			
			Handler.update(); // Show Splash Screen
			
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
				
				Handler.render();

				if(Handler.State < GameState.CINEMATIC && SKIP_INTRO_TEST)
					Handler.JumpTo(GameState.CINEMATIC);

				switch(Handler.State){
					case GameState.NONE:							
						Handler.SwitchState(GameState.SPLASH);
						result = Handler.load(Engine.Settings.RootDir + "/Install_Final.bmp");
						if(!result){
							stderr.printf("Failed to open BMP\n");
							run = false;
						}
						break;
					case GameState.SPLASH:
						stdout.printf("Showing the splash for a few seconds...\n");
						Posix.sleep(2);
						
						stdout.printf("Playing intro video...\n");
						Handler.SwitchState(GameState.CINEMATIC);
						result = Handler.load(Engine.Settings.RootDir + "/Data/English/Movies/EA_LOGO.BIK");

						Handler.onTextureReady.connect(onTexture);
						
						if(!result){
							stderr.printf("Failed to load EA_LOGO.bik\n");
							run = false;
						}
						break;
					case GameState.CINEMATIC:
						if(SKIP_INTRO_TEST){
							Handler.JumpTo(GameState.LOADING);
							test_model();
						} else {
							if(Handler.is_done()){
								Handler.SwitchState(GameState.LOADING);
							}
						}
						break;
				}
				Handler.update();
				
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
			}
			
			this.terminate();
		}
	}
}
