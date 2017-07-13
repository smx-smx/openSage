using GL;
using GLU;

namespace OpenSage {
	public class MainWindow {
		private GLFW.Window window;
		private EngineSettings settings;
		
		private bool create(){
			if(!GLFW.init()){
				stderr.printf("glfwInit failed\n");
				return false;
			}
			this.window = new GLFW.Window(this.settings.ScreenWidth, this.settings.ScreenHeight, "openSage", null, null);
			
			if(this.window == null){
				stderr.printf("Cannot create GLFW Window\n");
				return false;
			}
			GL.glViewport(0, 0, this.settings.ScreenWidth, this.settings.ScreenHeight);
			
			this.window.make_context_current();
			// Init GLEW after GLFW
			GLEW.glewInit();
			
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
			Handler handler = new Handler();
			handler.SwitchState(GameState.SPLASH);
			handler.load("./Bliss.bmp");
			
			while(!this.window.should_close){
				glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
				
				handler.update();
				this.window.swap_buffers();
				
				GLFW.poll_events();
			}
			
			this.terminate();
		}
	}
}
