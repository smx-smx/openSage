using OpenSage.Loaders;

namespace OpenSage {
	public enum GameState {
		NONE = 0,
		SPLASH = 1,
		CINEMATIC = 2,
		LOADING = 3
	}

	public class Handler {
		public GameState State {get; private set;}
		private void *stageHandle;
		
		public Handler(){
			this.State = GameState.NONE;
		}
		
		public bool load(string url){			
			switch(this.State){
				case GameState.SPLASH:
					return ((ImageLoader *)this.stageHandle)->load(url);
				case GameState.CINEMATIC:
					return ((VideoLoader *)this.stageHandle)->load(url);
				case GameState.LOADING:
				default:
					return false;
			}
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
			}
		}
		
		public void SwitchState(GameState state){
			FreeStage();
			switch(state){
				case GameState.SPLASH:
					this.stageHandle = (void *)new ImageLoader();
					break;
				case GameState.CINEMATIC:
					this.stageHandle = (void *)new VideoLoader();
					break;
				case GameState.LOADING:
					break;
			}
			
			this.State = state;
		}
		
		public bool update(){
			switch(this.State){
				case GameState.SPLASH:
					return ((ImageLoader *)this.stageHandle)->update();
				case GameState.CINEMATIC:
					return ((VideoLoader *)this.stageHandle)->update();
				case GameState.LOADING:
				default:
					return false;
			}
		}
	}
}
