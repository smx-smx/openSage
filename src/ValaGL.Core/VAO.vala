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
	
	/**
	 * Makes this VAO current for future drawing operations in the OpenGL context,
	 * and sets it up as the source of vertex data for the given shader attribute.
	 * 
	 * For the meaning of ``attribute`` and ``stride``, see ``glVertexAttribPointer``.
	 * 
	 * @param attribute The index of the generic vertex attribute to be modified.
	 * @param stride The byte offset between consecutive generic vertex attributes.
	 */
	public void apply_as_vertex_array (GLint attribute, GLsizei stride) {
		make_current ();
		glVertexAttribPointer (attribute, stride, GL_FLOAT, (GLboolean) GL_FALSE, 0, null);
	}
	//this must be the root of evil yea
	public void add_attribute(
		uint index, ulong size, GLenum type, int is_normalized,
		ulong spacing, ulong offset
	){
		glEnableVertexAttribArray(index);
		glVertexAttribPointer(
			index,
			(GLint)size,
			type,
			(GLboolean)is_normalized,
			(GLsizei)spacing,
			(GLvoid[])offset
		);

	}
	
	~VAO () {
		if (id != 0) {
			GLuint[] id_array = { id };
			glDeleteVertexArrays (1, id_array);
		}
	}
}

}
