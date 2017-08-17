using Av.Codec;
using Av.Format;
using Sw.Scale;
using Sw.Resample;
using Av.Util;

using GLib;
using GL;
using SDL;

using OpenSage.Support;
namespace OpenSage.Loaders.AV {

	private class AudioFrameConsumer {
		private unowned VideoPlayer player;

		private unowned Av.Format.Context format_ctx;
		private unowned Av.Codec.Context codec_ctx;
		private unowned Sw.Resample.Context? swr_ctx;	// Audio Resampler
		private Cancellable cts;
		
		private AutoResetEvent bufferFinished = new AutoResetEvent(false);
		
		private unowned AsyncQueue<QItem?> queue;
		
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
		
		private Audio.AudioDevice dev;
		
		private int audio_index;
		
		private Object clock_lock = null;
		
		private double clock_value = 0;
		public double audio_clock {
			get {
				lock (clock_lock){
					return clock_value;
				}
			}
			set {
				lock (clock_lock){
					clock_value = value;
				}
			}
		}
		
		private bool should_run = true;
		
		
		public AudioFrameConsumer(
			VideoPlayer player,
			Cancellable cts,
			Av.Format.Context format_ctx,
			Av.Codec.Context codec_ctx,
			int audio_index,
			AsyncQueue<QItem?> queue
		){
			this.player = player;
			this.cts = cts;
			this.format_ctx = format_ctx;
			this.codec_ctx = codec_ctx;
			this.audio_index = audio_index;
			
			this.queue = queue;
			
			this.cts.cancelled.connect(() => {
				should_run = false;
			});
			
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
			audio_spec.samples = (uint16)codec_ctx.frame_size;
			audio_spec.callback = (Audio.AudioFunc)fill_audio_buffer;
			audio_spec.userdata = (void *)this;

			ChannelLayout.Layout in_layout = ChannelLayout.Layout.get_default_channel_layout(
				codec_ctx.channels
			);

			//Sample.Format swr_format;
			//int swr_rate;
			
			swr_ctx = Sw.Resample.Context.alloc_set_opts(
				audio_out_layout,
				audio_out_format,
				audio_out_sample_rate,
				in_layout,
				codec_ctx.sample_fmt,
				codec_ctx.sample_rate,
				0,
				null
			);
			if(swr_ctx.init() < 0){
				stderr.printf("Failed to initialize SwrContext\n");
				return;
			}
			
			dev = Audio.AudioDevice (
				null,	//device name, use default
				false,	//not capture -> playback
				audio_spec,
				audio_dev_spec,
				Audio.AllowFlags.ANY_CHANGE
			);
			if(dev == 0){
				stderr.printf("Cannot open SDL audio: %s\n", get_error());
				return;
			}
							
			dev.pause(false);
		}
		
		// SDL calls this function with the buffer we need to fill
		private void fill_audio_buffer(uint8[] dst_buf){
			if(remaining_length == 0){
				bufferFinished.set();
				return;
			}

			Posix.memset((void *)dst_buf, 0, dst_buf.length);
			
			int length = dst_buf.length;
			if(dst_buf.length > remaining_length)
				// we have enough space for the whole buffer
				length = remaining_length;				
			
			Audio.mix_device(
				dst_buf,
				(uint8[])audio_cursor,
				sdl_out_format,
				length,
				Audio.MixFlags.MAXVOLUME
			);
			
			//stdout.printf("SDL Mixed %u (buf max: %u)\n", length, dst_buf.length);
			
			audio_cursor += length;
			remaining_length -= length;
			
			if(remaining_length == 0){
				bufferFinished.set();
			}
			
			//stdout.printf("AudioBuf remaining: %u\n", remaining_length);
		}
		
		public bool renderFrame(QItem item){
			bufferFinished.wait();

			unowned Frame frame = item.frame;

			double pts = 0;
			if(item.packet.dts != NOPTS_VALUE){
				pts = item.packet.dts;
			} else {
				pts = item.frame.best_effort_timestamp;
			}

			if(pts == NOPTS_VALUE){
				stdout.printf("NO AUDIO PTS!!!\n");
				return false;
			}
		
			/*if(pts > last_stamp){
				uint delta = (uint)(pts - last_stamp) * 1000;
				Posix.usleep(delta);
			}*/
			


			/*pts = Mathematics.rescale_q(
				(int64)pts,
				format_ctx.streams[audio_index].time_base,
				TIME_BASE_Q
			);*/

			
			player.audioReady.set();
			
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
					
			if(pts != NOPTS_VALUE){
				/*pts = Mathematics.rescale_q(
					(int64)pts,
					format_ctx.streams[audio_index].time_base,
					TIME_BASE_Q
				);*/

				audio_clock = format_ctx.streams[audio_index].time_base.q2d() * pts;
			}

			int buf_length = frame.nb_samples *
				audio_out_layout.nb_channels() *
				audio_out_format.get_bytes_per_sample();
			
			audio_cursor = (uint8 *)audio_buf;
			audio_buf.length = buf_length;
			remaining_length = buf_length;

			//stdout.printf("New buf length: %u\n", remaining_length);				
			return true;
		}
		
		
		public void* run(){
			while(should_run){
				QItem? item = queue.try_pop();
				if(item == null){
					bufferFinished.wait();
					dev.pause(true);
					player.playbackFinished.set();
					break;
				}

				audio_clock += (double)item.frame.nb_samples /
							   (double)format_ctx.streams[audio_index].codecpar.sample_rate;

				//stdout.printf("Audio Frame @ %p\n", frame);
				renderFrame(item);
			}
			return null;
		}
	}
}