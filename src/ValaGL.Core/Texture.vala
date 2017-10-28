using GL;

namespace ValaGL.Core {

public class Texture : Object {
	public GLuint id;

	public Texture() throws CoreError {
		GLuint id_array[1];
		glGenTextures(1, id_array);
		id = id_array[0];

		if(id == 0){
			throw new CoreError.TEXTURE_INIT("Cannot allocate texture");
		}
	}

	public void make_current(int textureUnit = 0, int type = GL_TEXTURE_2D){
		glActiveTexture(GL_TEXTURE0 + textureUnit);
		glBindTexture(type, id);
	}

	~Texture() {
		if (id != 0){
			GLuint[] id_array = { id };
			glDeleteTextures(1, id_array);
		}
	}
}

}