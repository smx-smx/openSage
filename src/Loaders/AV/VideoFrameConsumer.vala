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
	private class VideoFrameConsumer : FrameProvider {
		private unowned VideoPlayer player;
		
		private Sw.Scale.Context? scale_ctx;			// Video Scaler
		private unowned Av.Format.Context format_ctx;
		private unowned Av.Codec.Context codec_ctx;
		private Cancellable cts;
		
		private unowned AsyncQueue<QItem?> queue;
		
		private const int MAXQ_SIZE = 15;
		public AutoResetEvent slot_available = new AutoResetEvent(true);
		
		// Video frame size and frame buffer
		private int frameSize;
		private Frame frame_rgb;
		private uint8[] m_buf;
		
		private int video_index;
		
		private Object clock_lock = null;
		
		private double clock_value = 0;
		public double video_clock {
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
		
		private QItem? currentItem = null;

		private bool should_run = true;

		private AutoResetEvent show_frame = new AutoResetEvent(false);
		
		public VideoFrameConsumer(
			VideoPlayer player,
			Cancellable cts,
			Av.Format.Context format_ctx,
			Av.Codec.Context codec_ctx,
			int video_index,
			AsyncQueue<QItem?> queue
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

		private double synchronize_video(Frame frame, double pts){
			if(pts != 0){			
				video_clock = pts;
			} else {
				pts = video_clock;
			}

			double frame_delay = format_ctx.streams[video_index].time_base.q2d();
			frame_delay += frame.repeat_pict * (frame_delay * 0.5);
			video_clock += frame_delay;

			return pts;
		}
		
		public bool renderFrame(QItem item){
			double pts = 0;
			if(item.packet.dts != NOPTS_VALUE){
				pts = item.packet.dts;
			} else {
				pts = item.frame.best_effort_timestamp;
			}
			
			/*pts = Mathematics.rescale_q(
				(int64)pts,
				format_ctx.streams[video_index].time_base,
				TIME_BASE_Q
			);*/

			pts *= format_ctx.streams[video_index].time_base.q2d();

			if(pts == NOPTS_VALUE){
				stdout.printf("NO VIDEO PTS!!!\n");
				return false;
			}

			/*pts = Mathematics.rescale_q(
				(int64)pts,
				format_ctx.streams[video_index].time_base,
				TIME_BASE_Q
			);*/

			//delete item->packet;

			pts = synchronize_video(item.frame, pts);

			/* Make sure audio is not behind */
			/*if(pts >= player.audio_clock){
				player.audioReady.wait();
			}*/

			stdout.printf("aud: %llu\nvid: %llu\n",
				(int64)player.audio_clock,
				(int64)player.video_clock
			);

			if(pts >= player.audio_clock){
				GLib.Thread.usleep(10 * 1000);
				return false;
			}

			double audclk = player.audio_clock;

			unowned Frame frame = item.frame;

			if(scale_ctx.scale(
				frame.data,
				frame.linesize,
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

			//double delay = format_ctx.streams[video_index].time_base.q2d();
			//delay += frame->repeat_pict * (delay * 0.5);
			//stdout.printf("Delay: %u\n", (uint)delay);
	
			//stdout.printf("Sync delta: %u\n", sync_delta);
			return true;
		}
		
		public void* run(){
			bool fetch_next = true;
			QItem? current_item = null;

			while(should_run){
				if(fetch_next){
					current_item = queue.try_pop ();
					if(queue.length() < MAXQ_SIZE)
						slot_available.set();
				}

				if(current_item == null || player.playbackFinished.is_signaled()){
					stderr.printf("=> AudioFrameConsumer exiting\n");
					break;
				}

				//stdout.printf("Video Frame @ %p\n", frame);
				fetch_next = renderFrame(current_item);
			}
			return null;		
		}
	}
}