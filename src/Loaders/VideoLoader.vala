using Av.Codec;
using Av.Format;
using Sw.Scale;
using Sw.Resample;
using Av.Util;

using GLib;
using GL;
using SDL;

using OpenSage.Support;
namespace OpenSage.Loaders {
	private class AudioFrameConsumer {
		private unowned Av.Format.Context format_ctx;
		private unowned Av.Codec.Context codec_ctx;
		private unowned Sw.Resample.Context? swr_ctx;	// Audio Resampler
		private Cancellable cts;
		
		private AutoResetEvent bufferFinished = new AutoResetEvent(false);
		
		private unowned AsyncQueue<Frame?> queue;
		
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
		
		
		private int audio_index;
		
		private Object clock_lock = null;
		private int64 last_stamp = 0;
				
		public int64 audio_clock {
			get {
				lock (clock_lock){
					return last_stamp;
				}
			}
			set {
				lock (clock_lock){
					last_stamp = value;
				}
			}
		}
		
		private bool should_run = true;
		
		
		public AudioFrameConsumer(
			Cancellable cts,
			Av.Format.Context format_ctx,
			Av.Codec.Context codec_ctx,
			int audio_index,
			AsyncQueue<Frame?> queue
		){
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

			Sample.Format swr_format;
			int swr_rate;
			
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
			
			Audio.AudioDevice dev = Audio.AudioDevice (
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
		
		public bool renderFrame(Frame *frame){				
			bufferFinished.wait();
			
			int64 pts = frame->best_effort_timestamp;
			if(pts == NOPTS_VALUE){
				stdout.printf("NO AUDIO PTS!!!\n");
			}
			Mathematics.rescale_q(
				pts,
				format_ctx.streams[audio_index].time_base,
				TIME_BASE_Q
			);
			
			/*if(pts > last_stamp){
				uint delta = (uint)(pts - last_stamp) * 1000;
				Posix.usleep(delta);
			}*/
			audio_clock = pts;
			
			Av.Util.freep(&audio_buf);
			if(Sample.Samples.alloc(
				out audio_buf,
				null,
				audio_out_layout.nb_channels(),
				frame->nb_samples,
				audio_out_format,
				0
			) < 0){
				stderr.printf("Failed to allocate samples\n");
				return false;
			}
			
			if(swr_ctx.convert(
				(uint8 **)&audio_buf,
				frame->nb_samples,
				frame->data,
				frame->nb_samples
			) < 0){
				stderr.printf("Failed to resample audio\n");
				return false;
			}
					
			int buf_length = frame->nb_samples *
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
				Frame *frame = queue.pop();
				if(frame == null)
					break;

				//stdout.printf("Audio Frame @ %p\n", frame);
				renderFrame(frame);
				delete frame;
			}
			return null;
		}
	}
	
	private class VideoFrameConsumer : FrameProvider {
		private unowned VideoPlayer player;
		
		private Sw.Scale.Context? scale_ctx;			// Video Scaler
		private unowned Av.Format.Context format_ctx;
		private unowned Av.Codec.Context codec_ctx;
		private Cancellable cts;
		
		private unowned AsyncQueue<Frame?> queue;
		
		// Video frame size and frame buffer
		private int frameSize;
		private Frame frame_rgb;
		private uint8[] m_buf;
		
		private int video_index;
		
		private Object clock_lock = null;
		private int64 last_stamp = 0;
				
		public int64 video_clock {
			get {
				lock (clock_lock){
					return last_stamp;
				}
			}
			set {
				lock (clock_lock){
					last_stamp = value;
				}
			}
		}
		
		private bool should_run = true;
		
		public VideoFrameConsumer(
			VideoPlayer player,
			Cancellable cts,
			Av.Format.Context format_ctx,
			Av.Codec.Context codec_ctx,
			int video_index,
			AsyncQueue<Frame?> queue
		){
			this.player = player;
			this.cts = cts;
			this.format_ctx = format_ctx;
			this.codec_ctx = codec_ctx;
			this.video_index = video_index;
			this.queue = queue;
						
			this.cts.cancelled.connect(() => {
				should_run = false;
			});
						
			// Holds the video frame converted to RGB
			frame_rgb = new Frame();
					
			// Calculate Frame size	
			frameSize = Image.get_buffer_size(
				PixelFormat.RGB24,
				codec_ctx.width,
				codec_ctx.height,
				8
			);
			
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
		}
		
		public bool renderFrame(Frame *frame){		
			if(scale_ctx.scale(
				frame->data,
				frame->linesize,
				0,
				codec_ctx.height,
				frame_rgb.data,
				frame_rgb.linesize
			) < 0){
				stderr.printf("sws_scale failed\n");
				return false;
			}
			
			// We now have a scaled texture. Send a copy of the buffer
			// to the render queue
			onTextureReady(
				codec_ctx.width, codec_ctx.height,
				m_buf.copy()
			);
					
			int64 pts = frame->best_effort_timestamp;
			if(pts == NOPTS_VALUE){
				stdout.printf("NO VIDEO PTS!!!\n");
			}
			Mathematics.rescale_q(
				pts,
				format_ctx.streams[video_index].time_base,
				TIME_BASE_Q
			);
			
			uint sync_delta = 0;

			//stdout.printf("delay %u, frameDuration %.2f\n", (uint)delay, frameDuration);
			if(pts > last_stamp){
							
				int64 audio_clock = player.audio_clock;
				
				// If audio is ahead of us, speed up the video (sleep less)
				if(player.audio_clock > last_stamp){
					sync_delta = (uint)(audio_clock - last_stamp);
				}
				
				uint delta = (uint)((pts - last_stamp) * 1000) - sync_delta;
				Posix.usleep(delta);
			}
			last_stamp = pts;
			
			stdout.printf("Sync delta: %u\n", sync_delta);
			return true;
		}
		
		public void* run(){
			while(should_run){
				Frame *frame = queue.pop();
				if(frame == null)
					break;

				//stdout.printf("Video Frame @ %p\n", frame);
				renderFrame(frame);
				delete frame;
			}
			return null;		
		}
	}
	
	public class VideoPlayer {	
		private const int VIDEO_QUEUE_SIZE = 100;
		private const int AUDIO_QUEUE_SIZE = 100;
		
		private unowned AsyncQueue<Frame *> videoFrameQ;
		private unowned AsyncQueue<Frame *> audioFrameQ;
		
		private AutoResetEvent videoQEmpty = new AutoResetEvent(true);
		private AutoResetEvent audioQEmpty = new AutoResetEvent(true);
		
		private unowned Av.Format.Context format_ctx;
		private unowned Av.Codec.Context video_codec_ctx;
		private unowned Av.Codec.Context audio_codec_ctx;
		
		private int video_index;
		private int audio_index;
		
		private VideoFrameConsumer vid_task;
		private AudioFrameConsumer aud_task;
		
		// Producer Thread (this class)	
		private GLib.Thread<void *> playerThread;
		// Consumer Threads
		private GLib.Thread<void *> videoThread;
		private GLib.Thread<void *> audioThread;
		
		private Cancellable player_cts = new Cancellable();
		private Cancellable video_cts = new Cancellable();
		private Cancellable audio_cts = new Cancellable();
		
		public int64 audio_clock {
			get {
				return aud_task.audio_clock;
			}
		}
		
		public int64 video_clock {
			get {
				return vid_task.video_clock;
			}
		}
		
		private bool should_run = true;
		
		public VideoPlayer(
			Av.Format.Context format_ctx,
			
			AsyncQueue<Frame *> videoFrameQ,
			Av.Codec.Context video_codec_ctx,
			int video_index,
			
			AsyncQueue<Frame *> audioFrameQ,
			Av.Codec.Context audio_codec_ctx,
			int audio_index
		){
			this.format_ctx = format_ctx;
			
			this.videoFrameQ = videoFrameQ;
			this.video_codec_ctx = video_codec_ctx;
			this.video_index = video_index;
			
			this.audioFrameQ = audioFrameQ;
			this.audio_codec_ctx = audio_codec_ctx;
			this.audio_index = audio_index;
		}

		public bool play(VideoLoader *loader){
			playerThread = new GLib.Thread<void*>(null, this.run);
			
			// Video frame consumer
			vid_task = new VideoFrameConsumer(
				this,
				video_cts,
				format_ctx,
				video_codec_ctx,
				video_index,
				videoFrameQ
			);
			
			/* chain events */
			Handler.ChainEvents(vid_task, loader);
			videoThread = new GLib.Thread<void *>(null, vid_task.run);
			
			// Audio frame consumer
			aud_task = new AudioFrameConsumer(
				audio_cts,
				format_ctx,
				audio_codec_ctx,
				audio_index,
				audioFrameQ
			);
			audioThread = new GLib.Thread<void *>(null, aud_task.run);
			
			return true;
		}

		private bool processAudioPacket(Av.Codec.Packet packet){		
			Frame *frame = new Frame();
			
			//stdout.printf("Audio Packet Size: %u\n", packet.size);
			int ret = audio_codec_ctx.send_packet(packet);
			if(ret < 0){
				stdout.printf("Audio Packet Error: %s\n", Av.Util.Error.err2str(ret));
				if(ret == Av.Util.Error.EOF){
					return true;
				}
				return false;
			}
			
			// Receive the decoded audio packet
			ret = audio_codec_ctx.receive_frame(frame);
			if(ret < 0)
				return false;
			
			audioFrameQ.push(frame);		
			return true;
		}
		
		private bool processVideoPacket(Av.Codec.Packet packet){
			Frame *frame = new Frame();
			
			int ret = video_codec_ctx.send_packet(packet);
			if(ret < 0){
				stdout.printf("Video Packet Error: %s\n", Av.Util.Error.err2str(ret));
				if(ret == Av.Util.Error.EOF)
					return true;
				return false;
			}
			
			// Receive the decoded video packet
			ret = video_codec_ctx.receive_frame(frame);
			if(ret < 0)
				return false;
			
			/* TODO: This should be a Cond */
			while(videoFrameQ.length() > VIDEO_QUEUE_SIZE){
				Posix.usleep(1);
			}
			videoFrameQ.push(frame);			
			return true;
		}

		private bool processPacket(Av.Codec.Packet packet){
			if(packet.stream_index != audio_index &&
			   packet.stream_index != video_index
			){
				// not a packet we're interested in
				return false;
			}
			
			bool result = false;
			if(packet.stream_index == video_index){
				return processVideoPacket(packet);
			} else if(packet.stream_index == audio_index){
				return processAudioPacket(packet);
			}

			packet.unref();
			return true;
		}

		public void* run(){
			while(should_run){
				Av.Codec.Packet packet = new Av.Codec.Packet();
				// Get the encoded packet
				if(format_ctx.read_frame(packet) < 0)
					break;

				processPacket(packet);
			}
			
			videoQEmpty.wait();
			audioQEmpty.wait();
			return null;
		}
	}
	
	public class VideoLoader : FrameProvider {
			private AsyncQueue<Frame *> videoFrameQ = new AsyncQueue<Frame *>();
			private AsyncQueue<Frame *> audioFrameQ = new AsyncQueue<Frame *>();
		
			private unowned Av.Format.Context? format_ctx;	// Demuxer
			private Av.Codec.Context? video_codec_ctx;		// Video Decoder
			private Av.Codec.Context? audio_codec_ctx;		// Audio Decoder
			
			// Stream indexes
			private int video_index = -1;
			private int audio_index = -1;

			public VideoLoader(){
				Av.Codec.register_all();
				Av.Format.register_all();
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
				
				// The frame producer
				VideoPlayer player = new VideoPlayer(
					format_ctx,
					// video
					videoFrameQ,
					video_codec_ctx,
					video_index,
					// audio
					audioFrameQ,
					audio_codec_ctx,
					audio_index
				);
				player.play(this);
				return true;
				
			}
	}
}
