using GL;

namespace OpenSage.Loaders {
	public class FrameProvider {
		public signal void onFrameStart();
		public signal void onFrameEnd();
		public signal void onTextureReady(int width, int height, void *data);
	
		public FrameProvider *next = null;

		public delegate void FrameProviderFunction();
		public FrameProviderFunction? render_func = null;

		public void render(){
			assert(render_func != null);
			render_func();
		}

		public void set_renderer(FrameProviderFunction func){
			this.render_func = func;
		}
	}
}
