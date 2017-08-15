using GL;
using ValaGL.Core;
using FreeImage;

namespace OpenSage.Loaders {
	public class ImageLoader : FrameProvider {
		private static ValaGL.Core.Texture? LoadImage(string imagePath){
			ValaGL.Core.Texture texture = new ValaGL.Core.Texture();
			texture.make_current(GL_TEXTURE_2D);

			FreeImage.get_file_type(imagePath, 0);

			Format format = FreeImage.get_file_type(imagePath, 0);
			if(format == -1){
				stderr.printf("Couldn't find image %s\n", imagePath);
				return null;
			}

			if(format == Format.UNKNOWN){
				stderr.printf("Couldn't detect file type\n");
				return null;
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
			
			uint8 *bits = bmp32->get_bits();
			
			bmp32->convert_to_raw_bits(
				bits,
				(int)bmp32->get_pitch(),
				bmp32->get_bpp(),
				FreeImage.FI_RGBA_RED_MASK,
				FreeImage.FI_RGBA_GREEN_MASK,
				FreeImage.FI_RGBA_BLUE_MASK,
				false
			);

			glTexImage2D(
				GL_TEXTURE_2D,
				0,
				GL_RGBA8,
				(GLsizei)width,
				(GLsizei)height,
				0,
				GL_BGRA,
				GL_UNSIGNED_BYTE,
				//(GLvoid[])bmp32->get_bits()
				(GLvoid[])bits
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
				return null;
			}
			
			return texture;
		}
			
		public ValaGL.Core.Texture texture { get; private set; }
		public ImageLoader(){
			FreeImage.initialise();
		}
		
		~ImageLoader(){
			FreeImage.de_initialise();
		}
		
		public ValaGL.Core.Texture? get_frame(){
			return texture;
		}
		
		public bool load(string filename){
			this.texture = LoadImage(filename);
			if(this.texture == null)
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
			onFrameStart();
			TextureRenderer.RenderTexture(texture.id, TextureFlipMode.FLIP_BMP);
			onFrameEnd();
			return true;
		}
	}
}
