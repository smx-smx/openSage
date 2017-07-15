using GL;

public class TextureRenderer {
	public static void RenderTexture(GLuint texture){
		// Bind the texture
		glBindTexture(GL_TEXTURE_2D, texture);
		glEnable(GL_TEXTURE_2D);
		
		// Rotate upside down BMP with OpenGL instead of FreeImage (faster)
		glMatrixMode(GL_TEXTURE);
		glLoadIdentity();
		glScalef(-1.0f, -1.0f, 1.0f); //flip X and Y axis
		
		// Draw a textured cube across the viewport
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		
		glPushMatrix();
			glLoadIdentity();
			glBegin(GL_QUADS);
				glTexCoord2f(1.0f, 1.0f);
				glVertex3f(-1.0f,-1.0f, -1.0f);
				glTexCoord2f(0.0f, 1.0f);
				glVertex3f( 1.0f,-1.0f, -1.0f);
				glTexCoord2f(0.0f, 0.0f);
				glVertex3f( 1.0f, 1.0f, -1.0f);
				glTexCoord2f(1.0f, 0.0f);
				glVertex3f(-1.0f, 1.0f, -1.0f);
			glEnd();
		glPopMatrix();


		// Unbind the texture
		glDisable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, 0);
	}
}