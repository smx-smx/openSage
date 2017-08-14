using GL;

namespace ValaGL.Core {

/**
 * Encapsulation of an OpenGL vertex buffer object.
 * 
 * The underlying OpenGL buffer is destroyed when this object is finally unreferenced.
 */
public class VAO : Object {
	private GLuint id;
	
	/**
	 * Creates a vertex buffer object.
	 * 
	 * @param data Array to bind to the OpenGL buffer
	 */
	public VAO () throws CoreError {
		GLuint id_array[1];
		glGenVertexArrays (1, id_array);
		id = id_array[0];
		
		if (id == 0) {
			throw new CoreError.VAO_INIT ("Cannot allocate vertex array object");
		}
	}
	
	/**
	 * Makes this VAO current for future drawing operations in the OpenGL context.
	 */
	public void make_current () {
		glBindVertexArray(id);
	}
	

	~VAO () {
		if (id != 0) {
			GLuint[] id_array = { id };
			glDeleteVertexArrays (1, id_array);
		}
	}
}

}
