using GL;

namespace ValaGL.Core {

private static int ubo_bindingPoint = 0;

/**
 * Encapsulation of an OpenGL uniform buffer object.
 * 
 * The underlying OpenGL buffer is destroyed when this object is finally unreferenced.
 */
public class UBO : Object {
	private GLuint id;
	public int bindingPoint;

	/**
	 * Creates a uniform buffer object.
	 * 
	 * @param data Array to bind to the OpenGL buffer
	 */
	public UBO (void *data, size_t size, int bindingPoint) throws CoreError {
		GLuint id_array[1];
		glGenBuffers (1, id_array);
		id = id_array[0];
		
		if (id == 0) {
			throw new CoreError.UBO_INIT ("Cannot allocate uniform array object");
		}

		this.bindingPoint = bindingPoint;
	
		glBindBuffer (GL_UNIFORM_BUFFER, id);
		glBufferData (GL_UNIFORM_BUFFER, (GLsizei)size, (GLvoid[]) data, GL_STATIC_DRAW);
		glBindBuffer (GL_UNIFORM_BUFFER, 0);
	}
	
	/**
	 * Makes this UBO current for future drawing operations in the OpenGL context.
	 */
	public void make_current () {
		glBindBuffer(GL_UNIFORM_BUFFER, id);
		glBindBufferBase(GL_UNIFORM_BUFFER, bindingPoint, id);
	}
	

	~UBO () {
		if (id != 0) {
			GLuint[] id_array = { id };
			glDeleteBuffers (1, id_array);
		}
	}
}

}
