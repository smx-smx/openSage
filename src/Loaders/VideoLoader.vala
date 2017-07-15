using Av.Codec;
using Av.Format;
using Sw.Scale;
using Av.Util;

using GLib;
using GL;

namespace OpenSage.Loaders {
	public class VideoLoader {
			private Av.Codec.Context? codec_ctx;
			private unowned Av.Format.Context? format_ctx;
			private Sw.Scale.Context? scale_ctx;
			
			private int video_index = -1;
			private int audio_index = -1;
			private int frameSize;
			
			private Frame frame_rgb;
			private uint8[] m_buf;
						
			private int64 last_stamp = 0;
					
			//unowned Thread<bool> frame_provider;
			
			/*
			 * TODO: Switch to threads
			 * */
			public VideoLoader(){
				Av.Codec.register_all();
				Av.Format.register_all();
				
				// Create and start the thread
				//frame_provider = new Thread(this.update);
			}
			
			~VideoLoader(){
			}
			
			public bool load(string url){
				int err = Av.Format.Context.open_input(out format_ctx, url, null, null);
				if(err < 0){
					stderr.printf("Open failed: %s\n", Av.Util.Error.err2str(err));
					return false;
				}
				
				if(format_ctx.find_stream_info(null) < 0){
					stderr.printf("Failed to obtain stream info\n");
					return false;
				}
				
				// Find the first video and audio streams
				for(int i=0; i<format_ctx.streams.length; i++){
					if(video_index >= 0 && audio_index >= 0)
						break;
						
					unowned Stream s = format_ctx.streams[i];
					if(video_index < 0 && s.codecpar.codec_type == MediaType.VIDEO){
						video_index = i;
					}
					
					if(audio_index < 0 && s.codecpar.codec_type == MediaType.AUDIO){
						audio_index = i;
					}
				}
				
				if(video_index < 0){
					stderr.printf("No video stream found\n");
					return false;
				}

				// Find a decoder for this codec
				unowned Codec decoder = format_ctx.streams[video_index].codecpar.codec_id.find_decoder();
				if(decoder == null){
					stderr.printf("No decoder found\n");
					return false;
				}
								
				// Create a context for the decoder
				codec_ctx = new Av.Codec.Context(decoder);
				codec_ctx.set_parameters(format_ctx.streams[video_index].codecpar);
				
				if(codec_ctx.open(decoder, null) < 0){
					stderr.printf("Failed to open decoder\n");
					return false;
				}
				
				// Holds the video frame converted ro RGB
				frame_rgb = new Frame();
							
				frameSize = Image.get_buffer_size(PixelFormat.RGB24, codec_ctx.width, codec_ctx.height, 8);
				m_buf = new uint8[frameSize];
				Image.fill_arrays(
					frame_rgb.data,
					frame_rgb.linesize,
					m_buf,
					PixelFormat.RGB24,
					codec_ctx.width,
					codec_ctx.height,
					1
				);
				
				scale_ctx = Sw.Scale.Context.get_context(
					codec_ctx.width,
					codec_ctx.height,
					codec_ctx.pix_fmt,
					codec_ctx.width,
					codec_ctx.height,
					PixelFormat.RGB24,
					ScaleFlags.BILINEAR,
					null,
					null,
					null
				);
				
				return true;
				
			}
			
			/*
			 * TODO: switch to int for error reporting (negative values)
			 * */
			public bool update(){
				Av.Codec.Packet packet = new Av.Codec.Packet();
				
				if(format_ctx.read_frame(packet) < 0){
					// we didn't get any frame
					return false;
				}
				
				//stdout.printf("Got Frame\n");
				int ret = codec_ctx.send_packet(packet);
				if(ret < 0){
					if(ret == Av.Util.Error.EOF)
						return true;
					return false;
				}
				
				if(packet.stream_index != video_index){
					// not a frame we're interested in
					return false;
				}
				
				Frame frame = new Frame();
				ret = codec_ctx.receive_frame(frame);
				if(ret < 0){
					return false;
					/*
					if(ret == Av.Util.Error.EOF)
						return true;
					return false;
					*/
				}
									
				scale_ctx.scale(
					frame.data,
					frame.linesize,
					0,
					codec_ctx.height,
					frame_rgb.data,
					frame_rgb.linesize
				);
				
				GLuint[] texture = new GLuint[1]{ 0 };
				glGenTextures(1, texture);
				glBindTexture(GL_TEXTURE_2D, texture[0]);

				glTexImage2D(
					GL_TEXTURE_2D,              //Always GL_TEXTURE_2D
					0,
					GL_RGB,                              //Format OpenGL uses for image
					codec_ctx.width, codec_ctx.height, //Width and height
					0,                                   //The border of the image
					GL_RGB,                              
					GL_UNSIGNED_BYTE,                    //GL_UNSIGNED_BYTE, because pixels are 
					//stored as unsigned numbers
					(GLvoid[])frame_rgb.data[0]				//The actual pixel data
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
				
				TextureRenderer.RenderTexture(texture[0], TextureFlipMode.FLIP_VIDEO);

				double frameRate = format_ctx.streams[video_index].avg_frame_rate.q2d();
				double frameDuration = 1000.0f * frameRate;
				int64 delay = new DateTime.now_local().get_microsecond() - last_stamp;
				
				//stdout.printf("delay %u, frameDuration %.2f\n", (uint)delay, frameDuration);
				if(frameDuration > delay){
					uint delta = (uint)(frameDuration - delay);
					//stdout.printf("Delta: %u\n", (uint)delta);
					Posix.usleep(delta);
				}
				
				last_stamp = new DateTime.now_local().get_microsecond();
				stdout.flush();

				glDeleteTextures(1, texture);
				packet.unref();
				
				return true;
			}
	}
}
