using GL;

namespace ValaGL.Core {

/**
 * Encapsulation of an OpenGL shader storage buffer object.
 * 
 * The underlying OpenGL buffer is destroyed when this object is finally unreferenced.
 */
public class SSBO : Object {
	private GLuint id;
	public int bindingPoint;

	/**
	 * Creates a shader storage buffer object.
	 * 
	 * @param data Array to bind to the OpenGL buffer
	 */
	public SSBO (void *data, size_t size, int bindingPoint) throws CoreError {
		GLuint id_array[1];
		glGenBuffers (1, id_array);
		id = id_array[0];
		
		if (id == 0) {
			throw new CoreError.SSBO_INIT ("Cannot allocate shader storage array object");
		}
	
		this.bindingPoint = bindingPoint;

		glBindBuffer (GL_SHADER_STORAGE_BUFFER, id);
		glBufferData (GL_SHADER_STORAGE_BUFFER, (GLsizei)size, (GLvoid[]) data, GL_STATIC_DRAW);
		glBindBuffer (GL_SHADER_STORAGE_BUFFER, 0);
	}
	
	/**
	 * Makes this ssbo current for future drawing operations in the OpenGL context.
	 */
	public void make_current () {
		glBindBuffer(GL_SHADER_STORAGE_BUFFER, id);
		glBindBufferBase(GL_SHADER_STORAGE_BUFFER, bindingPoint, id);
	}
	

	~SSBO () {
		if (id != 0) {
			GLuint[] id_array = { id };
			glDeleteBuffers (1, id_array);
		}
	}
}

}
