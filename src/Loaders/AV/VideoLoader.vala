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
	public struct QItem {
		unowned Frame frame;
		unowned Packet packet;
	}

	
	public class VideoLoader : FrameProvider {
			private AsyncQueue<QItem?> videoFrameQ = new AsyncQueue<QItem?>();
			private AsyncQueue<QItem?> audioFrameQ = new AsyncQueue<QItem?>();
		
			private unowned Av.Format.Context? format_ctx;	// Demuxer
			private Av.Codec.Context? video_codec_ctx;		// Video Decoder
			private Av.Codec.Context? audio_codec_ctx;		// Audio Decoder
			
			private VideoPlayer player;
			
			// Stream indexes
			private int video_index = -1;
			private int audio_index = -1;

			public VideoLoader(){
				Av.Codec.register_all();
				Av.Format.register_all();
			}
			
			~VideoLoader(){
			}
			

			public bool is_playing(){
				return player.playbackFinished.is_signaled();	
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
				player = new VideoPlayer(
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
