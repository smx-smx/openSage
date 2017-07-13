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
		
		public void load(string url){			
			switch(this.State){
				case GameState.SPLASH:
					((ImageLoader *)this.stageHandle)->load(url);
					break;
				case GameState.CINEMATIC:
				case GameState.LOADING:
					break;
			}
		}
		
		public void FreeStage(){
			switch(this.State){
				case GameState.SPLASH:
					ImageLoader *ldr = (void *)new ImageLoader();
					delete ldr;
					break;
				case GameState.CINEMATIC:
				case GameState.LOADING:
					break;
			}
		}
		
		public void SwitchState(GameState state){
			FreeStage();
			switch(this.State){
				case GameState.NONE:
					this.State = GameState.SPLASH;
					this.stageHandle = (void *)new ImageLoader();
					break;
				case GameState.CINEMATIC:
				case GameState.LOADING:
					break;
			}
		}
		
		public bool update(){
			switch(this.State){
				case GameState.SPLASH:
					return ((ImageLoader *)this.stageHandle)->update();
				case GameState.CINEMATIC:
				case GameState.LOADING:
				default:
					return false;
			}
		}
	}
}
