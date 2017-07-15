using GL;
using FreeImage;

namespace OpenSage.Loaders {
	public class ImageLoader {
		private static GLuint LoadImage(string imagePath){
			GLuint[] texture = new GLuint[1]{ 0 };
			glGenTextures(1, texture);
			glBindTexture(GL_TEXTURE_2D, texture[0]);

			FreeImage.get_file_type(imagePath, 0);

			Format format = FreeImage.get_file_type(imagePath, 0);
			if(format == -1){
				stderr.printf("Couldn't find image %s\n", imagePath);
				return -1;
			}

			if(format == Format.UNKNOWN){
				stderr.printf("Couldn't detect file type\n");
				return -1;
			}

			Bitmap *bmp32;

			Bitmap bmp = FreeImage.load(format, imagePath);
			uint bpp = bmp.get_bpp();
			if(bpp == 32){
				bmp32 = bmp;
			} else {
				stdout.printf("Converting to 32bit\n");
				bmp32 = bmp.convert_to_32_bits();
			}
			
			uint width = bmp32->get_width();
			uint height = bmp32->get_height();
			
			glTexImage2D(
				GL_TEXTURE_2D,
				0,
				GL_RGBA8,
				(GLsizei)width,
				(GLsizei)height,
				0,
				GL_BGRA,
				GL_UNSIGNED_BYTE,
				(GLvoid[])bmp32->get_bits()
			);
			
			GLenum minification = GL_LINEAR;
			GLenum magnification = GL_LINEAR;
			
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, (GLint)minification);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, (GLint)magnification);
			
			if (
				minification == GL_LINEAR_MIPMAP_LINEAR   ||
				minification == GL_LINEAR_MIPMAP_NEAREST  ||
				minification == GL_NEAREST_MIPMAP_LINEAR  ||
				minification == GL_NEAREST_MIPMAP_NEAREST
			){
				glGenerateMipmap(GL_TEXTURE_2D);
			}
			
			GLenum glError = glGetError();
			if(glError != 0){
				stderr.printf("An error occured\n");
				return -1;
			}
			
			return texture[0];
		}
			
		public GLuint texture { get; private set; }
		public ImageLoader(){
			FreeImage.initialise();
		}
		
		~ImageLoader(){
			FreeImage.de_initialise();
		}
		
		public GLuint get_frame(){
			return texture;
		}
		
		public bool load(string filename){
			this.texture = LoadImage(filename);
			if(this.texture == -1)
				return false;
			return true;
		}
		
		/*
		 * This function is shaped to work for the splash screen ATM
		 * it will draw a single image across the whole viewport.
		 * For 3D model textures it's likely better to use a different class
		 * in the (TODO) model loader
		 * */
		public bool update(){
			TextureRenderer.RenderTexture(texture, TextureFlipMode.FLIP_BMP);
			return true;
		}
	}
}
