using GL;
using GLU;

namespace OpenSage {
	public class MainWindow {
		private GLFW.Window window;
		private EngineSettings settings;
		
		private static void on_debug_message(
			GLenum source, GLenum type, GLuint id,
			GLenum severity, GLsizei length, string message, void* userParam
		){
			stdout.printf("[OPENGL] %s\n", message);
		}
		
		private bool create(){
			if(!GLFW.init()){
				stderr.printf("glfwInit failed\n");
				return false;
			}
			GLFW.WindowHint.OPENGL_DEBUG_CONTEXT.set_bool(true);
			this.window = new GLFW.Window(this.settings.ScreenWidth, this.settings.ScreenHeight, "openSage", null, null);
			
			if(this.window == null){
				stderr.printf("Cannot create GLFW Window\n");
				return false;
			}
					
			this.window.make_context_current();
			// Init GLEW after GLFW
			GLEW.glewInit();
			
			glEnable(GL_DEBUG_OUTPUT);
			glDebugMessageCallback((GLDEBUGPROC)on_debug_message, null);
			
			glViewport(0, 0, this.settings.ScreenWidth, this.settings.ScreenHeight);
			
			return true;
		}

		private void terminate(){
			GLFW.terminate();
		}

		public MainWindow(EngineSettings settings){
			this.settings = settings;
			if(!this.create()){
				this.terminate();
			}
		}
	
		public void MainLoop(){
			bool result;
							
			Handler handler = new Handler();
			handler.SwitchState(GameState.SPLASH);
			result = handler.load(settings.RootDir + "/Install_Final.bmp");
			if(!result){
				stderr.printf("Failed to open BMP\n");
				this.window.should_close = true;
			}
			
			while(!this.window.should_close){
				glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
				
				handler.update();
				this.window.swap_buffers();
				
				GLFW.poll_events();
				
				if(handler.State == GameState.SPLASH){
					//Posix.sleep(2);
					handler.SwitchState(GameState.CINEMATIC);
					result = handler.load(settings.RootDir + "/Data/English/Movies/EA_LOGO.BIK");
					if(!result){
						stderr.printf("Failed to load EA_LOGO.bik\n");
						this.window.should_close = true;
					}
				}
			}
			
			this.terminate();
		}
	}
}
