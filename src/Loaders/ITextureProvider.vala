using GL;

namespace OpenSage {
	public interface ITextureProvider : Object {
		public abstract bool load(string url);
		public abstract bool update();
	}
}
