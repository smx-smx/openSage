using GL;

namespace OpenSage.Loaders {
	public class FrameProvider {
		public signal void onFrameStart();
		public signal void onFrameEnd();
		public signal void onTextureReady(int width, int height, void *data);
	}
}
