using GL;

public enum TextureFlipMode {
	FLIP_BMP = 0,
	FLIP_VIDEO = 1
}

public class TextureRenderer {
	public static void RenderTexture(GLuint texture, TextureFlipMode? flipMode = null){
		// Bind the texture
		glBindTexture(GL_TEXTURE_2D, texture);
		glEnable(GL_TEXTURE_2D);
		
		if(flipMode == null){
			return;
		}

		// Rotate upside down BMP with OpenGL instead of FreeImage (faster)
		glMatrixMode(GL_TEXTURE);
		glLoadIdentity();

		float f_x, f_y, f_z;
		f_x = f_y = f_z = 1.0f;

		switch(flipMode){
			case TextureFlipMode.FLIP_BMP:
				f_y = f_x = -1.0f;
				break;
			case TextureFlipMode.FLIP_VIDEO:
				f_x = -1.0f;
				break;
			default:
				break;
		}
			
		glScalef(f_x, f_y, f_z);

		
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
