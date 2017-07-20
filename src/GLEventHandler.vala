using GL;
using OpenSage.Loaders;

namespace OpenSage {

/*
 * Dispatcher for various OpenGL related tasks
 * It can request clear/swap via FrameProvider
 * */
public class GLEventHandler : FrameProvider {
	public GLEventHandler(){}
	
	public void RenderTexture2D (
		int width, int height,
		void *data
	){
		onFrameStart();
		
		GLuint[] texture = new GLuint[1]{ 0 };
		glGenTextures(1, texture);
		glBindTexture(GL_TEXTURE_2D, texture[0]);

		glTexImage2D(
			GL_TEXTURE_2D,
			0,
			GL_RGB,
			width, height,
			0,
			GL_RGB,                              
			GL_UNSIGNED_BYTE,
			(GLvoid[])data
		);   

		GLenum minification = GL_LINEAR;
		GLenum magnification = GL_LINEAR;
		
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, (GLint)minification);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, (GLint)magnification);
		
		if(
			minification == GL_LINEAR_MIPMAP_LINEAR   ||
			minification == GL_LINEAR_MIPMAP_NEAREST  ||
			minification == GL_NEAREST_MIPMAP_LINEAR  ||
			minification == GL_NEAREST_MIPMAP_NEAREST
		){
			glGenerateMipmap(GL_TEXTURE_2D);
		}
		
		
		TextureRenderer.RenderTexture(texture[0], TextureFlipMode.FLIP_VIDEO);
		onFrameEnd();
		
		glDeleteTextures(1, texture);
	}
}

}
