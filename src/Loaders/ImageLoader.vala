using GL;
using ValaGL.Core;
using FreeImage;

namespace OpenSage.Loaders {
	public class ImageLoader : FrameProvider {
		private static Format get_type_file(string path){
			return FreeImage.get_file_type(path, 0);
		}
		
		public struct FIBitmap {
			FreeImage.Memory* mem; //optional, if loading from memory
			FreeImage.Bitmap* bmp;
		}

		private static FIBitmap? load_file(string path, Format? format = null){
			if(format == null)
				format = get_type_file(path);
			if(!checkFormat(format))
				return null;
			FIBitmap bmp = {null, FreeImage.load(format, path)};
			return bmp;
		}

		private static FIBitmap? load_mem(uint8[] buf, Format? format = null){
			FIBitmap fi_bmp = FIBitmap();
			fi_bmp.mem = new FreeImage.Memory(buf);
			
			if(format == null)
				format = fi_bmp.mem->get_file_type();
			if(!checkFormat(format))
				return null;

			fi_bmp.bmp = fi_bmp.mem->load(format);
			return fi_bmp;
		}

		private static bool checkFormat(Format format){
			if(format == -1){
				stderr.printf("Couldn't find image\n");
				return false;
			}

			if(format == Format.UNKNOWN){
				stderr.printf("Couldn't detect file type\n");
				return false;
			}
			
			return true;
		}

		private static ValaGL.Core.Texture? loadBitmap(Bitmap bmp){
			Bitmap *bmp32;

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

			ValaGL.Core.Texture texture = new ValaGL.Core.Texture();
			texture.make_current(0, GL_TEXTURE_2D);

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

		public static ValaGL.Core.Texture? LoadStream(uint8[] buf){
			FIBitmap bmp = load_mem(buf);
			delete bmp.mem;
			
			ValaGL.Core.Texture? texture = loadBitmap(bmp.bmp);
			delete bmp.bmp;
			return texture;
		}

		public static ValaGL.Core.Texture? LoadFile(string imagePath){
			FIBitmap bmp = load_file(imagePath);
			ValaGL.Core.Texture? texture = loadBitmap(bmp.bmp);
			delete bmp.bmp;
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
			this.texture = LoadFile(filename);
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
