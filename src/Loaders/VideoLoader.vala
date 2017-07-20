using Av.Codec;
using Av.Format;
using Sw.Scale;
using Sw.Resample;
using Av.Util;

using GLib;
using GL;
using SDL;

namespace OpenSage.Loaders {
	public class VideoLoader {
			const int MAX_AUDIO_FRAME_SIZE = 192000; // 1 second of 48khz 32bit audio
		
			private unowned Av.Format.Context? format_ctx;	// Demuxer
			private Av.Codec.Context? video_codec_ctx;		// Video Decoder
			private Av.Codec.Context? audio_codec_ctx;		// Audio Decoder
			
			private Sw.Scale.Context? scale_ctx;			// Video Scaler
			private unowned Sw.Resample.Context? swr_ctx;	// Audio Resampler
			
			// Stream indexes
			private int video_index = -1;
			private int audio_index = -1;
			
			// Video frame size and frame buffer
			private int frameSize;
			private Frame frame_rgb;
			private uint8[] m_buf;

			// Video timestamp (for FPS/SampleRate syncronization)
			private int64 last_stamp = 0;
			
			// Audio device and buffer
			Audio.AudioSpec audio_dev_spec = Audio.AudioSpec();
			private uint8[] audio_buf;
			private uint8 *audio_cursor;
			private int remaining_length = 0;
			private int audio_buffer_size;
			
			// Audio output config
			private int audio_out_sample_rate = 44100;
			private ChannelLayout.Layout audio_out_layout = ChannelLayout.Layout.STEREO;
			private Sample.Format audio_out_format = Sample.Format.S32;
			private Audio.AudioFormat sdl_out_format = Audio.AudioFormat.S32;

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
			
			// SDL calls this function with the buffer we need to fill
			private void fill_audio_buffer(uint8[] dst_buf){
				if(remaining_length == 0){
					return;
				}

				Posix.memset((void *)dst_buf, 0, dst_buf.length);
				
				int length = dst_buf.length;
				if(dst_buf.length > remaining_length)
					// we have enough space for the whole buffer
					length = remaining_length;

/*				
				{
					var file = File.new_for_path ("out.pcm");
					if (file.query_exists ()) { file.delete (); }
					var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
					dos.write(audio_buf);
				}
				Posix.exit(1);
*/
				
				
				Audio.mix_device(
					dst_buf,
					(uint8[])audio_cursor,
					sdl_out_format,
					length,
					Audio.MixFlags.MAXVOLUME
				);
				
				stdout.printf("SDL Mixed %u (buf max: %u)\n", length, dst_buf.length);
				
				audio_cursor += length;
				remaining_length -= length;
				
				stdout.printf("AudioBuf remaining: %u\n", remaining_length);
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
						stdout.printf("Video Stream Index: %u\n", video_index);
					}
					
					if(audio_index < 0 && s.codecpar.codec_type == MediaType.AUDIO){
						audio_index = i;
						stdout.printf("Audio Stream Index: %u\n", audio_index);
					}
				}
				
				if(video_index < 0){
					stderr.printf("No video stream found\n");
					return false;
				}

				// Find a decoder for this codec
				unowned Codec video_decoder = format_ctx.streams[video_index].codecpar.codec_id.find_decoder();
				if(video_decoder == null){
					stderr.printf("No video decoder found\n");
					return false;
				}
				
				stdout.printf("Video Codec: %s\n", video_decoder.name);
								
				// Create a context for the decoder
				video_codec_ctx = new Av.Codec.Context(video_decoder);
				video_codec_ctx.set_parameters(format_ctx.streams[video_index].codecpar);
				
				if(video_codec_ctx.open(video_decoder, null) < 0){
					stderr.printf("Failed to open video decoder\n");
					return false;
				}
				
				// Holds the video frame converted to RGB
				frame_rgb = new Frame();
							
				frameSize = Image.get_buffer_size(PixelFormat.RGB24, video_codec_ctx.width, video_codec_ctx.height, 8);
				m_buf = new uint8[frameSize];
				Image.fill_arrays(
					frame_rgb.data,
					frame_rgb.linesize,
					m_buf,
					PixelFormat.RGB24,
					video_codec_ctx.width,
					video_codec_ctx.height,
					1
				);
				
				scale_ctx = Sw.Scale.Context.get_context(
					video_codec_ctx.width,
					video_codec_ctx.height,
					video_codec_ctx.pix_fmt,
					video_codec_ctx.width,
					video_codec_ctx.height,
					PixelFormat.RGB24,
					ScaleFlags.BILINEAR,
					null,
					null,
					null
				);

				if(audio_index < 0){
					stderr.printf("Skipping Audio init: no audio streams found\n");
					return true;
				}
				
				// Find a decoder for this codec
				unowned Codec audio_decoder = format_ctx.streams[audio_index].codecpar.codec_id.find_decoder();
				if(audio_decoder == null){
					stderr.printf("No audio decoder found\n");
					return false;
				}
				stdout.printf("Audio Codec: %s\n", audio_decoder.name);
				
				// Create a context for the decoder
				audio_codec_ctx = new Av.Codec.Context(audio_decoder);
				audio_codec_ctx.set_parameters(format_ctx.streams[audio_index].codecpar);
				
				if(audio_codec_ctx.open(audio_decoder, null) < 0){
					stderr.printf("Failed to open audio decoder\n");
					return false;
				}
				
				// Init Audio
				int num_channels = audio_out_layout.nb_channels();
				
				audio_buffer_size = audio_out_format.get_buffer_size(
					null,
					num_channels,
					audio_out_sample_rate,
					true
				);
					

				Audio.AudioSpec audio_spec = Audio.AudioSpec();
				audio_spec.freq = audio_out_sample_rate;
				audio_spec.format = Audio.AudioFormat.S32SYS;
				audio_spec.channels = (uint8)num_channels;
				audio_spec.silence = 0;
				audio_spec.samples = (uint16)audio_codec_ctx.frame_size;
				audio_spec.callback = (Audio.AudioFunc)fill_audio_buffer;
				audio_spec.userdata = (void *)this;
	
				ChannelLayout.Layout in_layout = ChannelLayout.Layout.get_default_channel_layout(audio_codec_ctx.channels);

				Sample.Format swr_format;
				int swr_rate;
				
				swr_ctx = swr_ctx.alloc_set_opts(
					audio_out_layout,
					audio_out_format,
					audio_out_sample_rate,
					in_layout,
					audio_codec_ctx.sample_fmt,
					audio_codec_ctx.sample_rate,
					0,
					null
				);
				if(swr_ctx.init() < 0){
					stderr.printf("Failed to initialize SwrContext\n");
					return false;
				}
				
				Audio.AudioDevice dev = Audio.AudioDevice (
					null,	//device name, use default
					false,	//not capture -> playback
					audio_spec,
					audio_dev_spec,
					Audio.AllowFlags.ANY_CHANGE
				);
				if(dev == 0){
					stderr.printf("Cannot open SDL audio: %s\n", get_error());
					return false;
				}
								
				dev.pause(false);
				return true;
				
			}
			
			private bool update_audio(Frame frame){
				//TODO: Event
				while(remaining_length > 0)
					Posix.usleep(1);
				
				
				Av.Util.freep(&audio_buf);
				if(Sample.Samples.alloc(
					out audio_buf,
					null,
					audio_out_layout.nb_channels(),
					frame.nb_samples,
					audio_out_format,
					0
				) < 0){
					stderr.printf("Failed to allocate samples\n");
					return false;
				}
				
				if(swr_ctx.convert(
					(uint8 **)&audio_buf,
					frame.nb_samples,
					frame.data,
					frame.nb_samples
				) < 0){
					stderr.printf("Failed to resample audio\n");
					return false;
				}
						
				int buf_length = frame.nb_samples *
					audio_out_layout.nb_channels() *
					audio_out_format.get_bytes_per_sample();
				
				audio_cursor = (uint8 *)audio_buf;
				audio_buf.length = buf_length;
				remaining_length = buf_length;

				stdout.printf("New buf length: %u\n", remaining_length);				
				return true;
			}

			private bool update_video(Frame frame){
				scale_ctx.scale(
					frame.data,
					frame.linesize,
					0,
					video_codec_ctx.height,
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
					video_codec_ctx.width, video_codec_ctx.height, //Width and height
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
				return true;
			}

			/*
			 * TODO: switch to int for error reporting (negative values)
			 * */
			public bool update(){
				Av.Codec.Packet packet = new Av.Codec.Packet();
				
				// Get the encoded packet
				if(format_ctx.read_frame(packet) < 0){
					return false;
				}
				
				if(packet.stream_index != audio_index &&
				   packet.stream_index != video_index
				){
					// not a packet we're interested in
					return false;
				}
						
				Frame frame = new Frame();
				
				bool result = false;
				if(packet.stream_index == video_index){
					int ret = video_codec_ctx.send_packet(packet);
					if(ret < 0){
						if(ret == Av.Util.Error.EOF)
							return true;
						return false;
					}
					
					// Receive the decoded video packet
					ret = video_codec_ctx.receive_frame(frame);
					if(ret < 0)
						return false;
					result = update_video(frame);
				} else if(packet.stream_index == audio_index){
					stdout.printf("Audio Packet Size: %u\n", packet.size);
					int ret = audio_codec_ctx.send_packet(packet);
					if(ret < 0){
						stdout.printf("%s\n", Av.Util.Error.err2str(ret));
						if(ret == Av.Util.Error.EOF){
							return true;
						}
						return false;
					}
					
					// Receive the decoded audio packet
					ret = audio_codec_ctx.receive_frame(frame);
					if(ret < 0)
						return false;
					result = update_audio(frame);
				}

				packet.unref();
				return result;
			}
	}
}
