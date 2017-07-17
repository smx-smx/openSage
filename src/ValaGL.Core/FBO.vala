using GL;

namespace ValaGL.Core {
	public class FBO : Object {
		private GLuint id;

		public FBO () throws CoreError {
			GLuint id_array[1];
			glGenFramebuffers(1, id_array);
			id = id_array[0];

			if(id == 0){
				throw new CoreError.FBO_INIT ("Cannot allocate frame buffer object");
			}
		}

		public void make_current(GLenum target){
			glBindFramebuffer(target, id);
		}

		~FBO() {
			if(id != 0){
				GLuint[] id_array = { id };
				glDeleteFramebuffers(1, id_array);
			}
		}
	}
}