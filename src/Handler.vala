using OpenSage.Loaders;
using OpenSage.Loaders.AV;

namespace OpenSage {
	public enum GameState {
		NONE = 0,
		SPLASH = 1,
		CINEMATIC = 2,
		LOADING = 3,
		INGAME = 4
	}

	public class Handler : FrameProvider {
		public GameState State {get; private set;}
		public void *stageHandle;

		public Handler(){
			this.State = GameState.NONE;
			this.set_renderer(render_func);
		}

		private new void render_func(){
			FrameProvider *current = this;
			while(true){
				if(current->next == null)
					break;				
				current = current->next;
				if(current->render_func != null)
					current->render();

			}
		}
		
		public void JumpTo(GameState state){
			this.State = state;
		}

		public void Chain(FrameProvider prv){
			ChainEvents(prv, this);
		}

		/* Chains events from one FrameProvider to another */
		public static void ChainEvents(FrameProvider prv, FrameProvider dst){
			prv.onFrameStart.connect(() => {
				dst.onFrameStart();
			});
			prv.onFrameEnd.connect(() => {
				dst.onFrameEnd();
			});
			prv.onTextureReady.connect((width, height, data) => {
				dst.onTextureReady(width, height, data);
			});
			dst.next = prv;
		}
		
		public bool load(string url){			
			switch(this.State){
				case GameState.SPLASH:
					return ((ImageLoader *)this.stageHandle)->load(url);
				case GameState.CINEMATIC:
					return ((VideoLoader *)this.stageHandle)->load(url);
				case GameState.LOADING:
				case GameState.INGAME:
				default:
					return false;
			}
		}
		
		public bool is_done(){
			if(State == GameState.CINEMATIC)
				return ((VideoLoader *)stageHandle)->is_playing();
			return true;
		}

		public void FreeStage(){
			switch(this.State){
				case GameState.SPLASH:
					ImageLoader *ldr = (ImageLoader *)this.stageHandle;
					delete ldr;
					break;
				case GameState.CINEMATIC:
					VideoLoader *ldr = (VideoLoader *)this.stageHandle;
					delete ldr;
					break;
				case GameState.LOADING:
					break;
				case GameState.INGAME:
					break;
			}
		}
		
		public void SwitchState(GameState state){
			FreeStage();
			switch(state){
				case GameState.SPLASH:
					this.stageHandle = (void *)new ImageLoader();
					ChainEvents((FrameProvider *)this.stageHandle, this);
					break;
				case GameState.CINEMATIC:
					this.stageHandle = (void *)new VideoLoader();
					ChainEvents((FrameProvider *)this.stageHandle, this);
					break;
				case GameState.LOADING:
					break;
				case GameState.INGAME:
					break;
			}
			
			this.State = state;
		}
		
		public bool update(){
			switch(this.State){
				case GameState.SPLASH:
					return ((ImageLoader *)this.stageHandle)->update();
				case GameState.CINEMATIC:
				case GameState.LOADING:
				case GameState.INGAME:
				default:
					return false;
			}
		}
	}
}
