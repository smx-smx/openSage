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

	public class VideoPlayer {	
		private const int VIDEO_QUEUE_SIZE = 100;
		private const int AUDIO_QUEUE_SIZE = 100;
		
		private unowned AsyncQueue<QItem?> videoFrameQ;
		private unowned AsyncQueue<QItem?> audioFrameQ;
		
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

		public AutoResetEvent audioReady = new AutoResetEvent(true);
		
		//private Cancellable player_cts = new Cancellable();
		private Cancellable video_cts = new Cancellable();
		private Cancellable audio_cts = new Cancellable();

		public ManualResetEvent playbackFinished = new ManualResetEvent(false);
		
		public double audio_clock {
			get {
				return aud_task.audio_clock;
			}
		}
		
		public double video_clock {
			get {
				return vid_task.video_clock;
			}
		}
		
		private bool should_run = true;
		
		public VideoPlayer(
			Av.Format.Context format_ctx,
			
			AsyncQueue<QItem?> videoFrameQ,
			Av.Codec.Context video_codec_ctx,
			int video_index,
			
			AsyncQueue<QItem?> audioFrameQ,
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

		~VideoPlayer(){
			audioThread.join();
			videoThread.join();
			playerThread.join();
		}

		public bool play(VideoLoader *loader){
			playerThread = new GLib.Thread<void*>(null, this.run);
			
			// Audio frame consumer
			aud_task = new AudioFrameConsumer(
				this,
				audio_cts,
				format_ctx,
				audio_codec_ctx,
				audio_index,
				audioFrameQ
			);
			audioThread = new GLib.Thread<void *>(null, aud_task.run);
			
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
			
			return true;
		}

		private bool processCodecPacket(
			Av.Codec.Context codec_ctx,
			Av.Codec.Packet packet,
			AsyncQueue<QItem?> queue
		){
			//stdout.printf("Packet Size: %u\n", packet.size);
			int ret = codec_ctx.send_packet(packet);
			if(ret == Av.Util.Error.EOF || ret == Av.Util.Error.from_posix(Posix.EAGAIN))
				return true;
			else if(ret < 0) {
				stdout.printf("Audio Packet Error: %s\n", Av.Util.Error.err2str(ret));
				return false;
			}
			
			// Receive the decoded audio packet
			while(true){
				Frame *frame = new Frame();
				ret = codec_ctx.receive_frame(frame);
				if(ret < 0 && ret != Av.Util.Error.EOF)
					return false;

				QItem item = QItem();
				item.frame = frame;
				item.packet = packet;
				queue.push(item);
			}
			
			return true;
		}

		private bool processPacket(Av.Codec.Packet packet){
			if(packet.stream_index != audio_index &&
			   packet.stream_index != video_index
			){
				// not a packet we're interested in
				return false;
			}
			
			if(packet.stream_index == video_index){
				return processCodecPacket(video_codec_ctx, packet, videoFrameQ);
			} else if(packet.stream_index == audio_index){
				return processCodecPacket(audio_codec_ctx, packet, audioFrameQ);
			}

			packet.unref();
			return true;
		}

		public void* run(){
			while(should_run){
				Av.Codec.Packet packet = new Av.Codec.Packet();
				
				// Get the encoded packet
				int ret = format_ctx.read_frame(packet);
				if(ret == Av.Util.Error.EOF){
					should_run = false;
					stderr.printf("=> PlayerThread exiting\n");
					break;
				}

				processPacket(packet);
			}
			
			videoQEmpty.wait();
			audioQEmpty.wait();
			return null;
		}
	}
}