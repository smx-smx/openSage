using Av.Util;
[CCode(cheader_filename = "libswresample/swresample.h")]
namespace Sw.Resample {
	[CCode(cprefix = "SWR_FLAG_")]
	[Flags]
	public enum Flags {
		RESAMPLE
	}

	[CCode(cname = "enum SwrDitherType", cprefix = "SWR_DITHER_")]
	public enum DitherType {
		NONE = 0,
		RECTANGULAR,
		TRIANGULAR,
		TRIANGULAR_HIGHPASS,

		NS = 64,         ///< not part of API/ABI
		NS_LIPSHITZ,
		NS_F_WEIGHTED,
		NS_MODIFIED_E_WEIGHTED,
		NS_IMPROVED_E_WEIGHTED,
		NS_SHIBATA,
		NS_LOW_SHIBATA,
		NS_HIGH_SHIBATA,
		NB;              ///< not part of API/ABI
	}
	
	[CCode(cname = "enum SwrEngine", cprefix = "SWR_ENGINE_")]
	public enum Engine {
		SWR,
		SOXR,
		NB;
	}
	
	[CCode(cname = "FilterType", cprefix = "SWR_FILTER_TYPE_")]
	public enum FilterType {
		CUBIC,
		BLACKMAN_NUTTALL,
		KAISER;
	}
	
	[Compact, CCode(cname = "SwrContext", free_function = "swr_free", free_function_address_of = true)]
	public class Context {
		[CCode(cname = "swr_init")]
		public int init();
		
		[CCode(cname = "swr_is_initialized")]
		public int is_initialized();
		
		[CCode(cname = "swr_alloc")]
		public Context();
	
		[CCode(cname = "swr_close")]
		public void close();
	
		[CCode(cname = "swr_alloc_set_opts")]
		private static unowned Context _alloc_set_opts(
			Context *s,
			ChannelLayout.Layout out_ch_layout,
			Sample.Format out_sample_fmt,
			int out_sample_rate, 
			ChannelLayout.Layout in_ch_layout,
			Sample.Format in_sample_fmt,
			int in_sample_rate,
			int log_offset,
			void *log_ctx
		);
	
		[CCode(cname = "swr_alloc_set_opts")]
		public unowned Context set_opts(
			ChannelLayout.Layout out_ch_layout,
			Sample.Format out_sample_fmt,
			int out_sample_rate, 
			ChannelLayout.Layout in_ch_layout,
			Sample.Format in_sample_fmt,
			int in_sample_rate,
			int log_offset,
			void *log_ctx
		);

		public static unowned Context alloc_set_opts(
			ChannelLayout.Layout out_ch_layout,
			Sample.Format out_sample_fmt,
			int out_sample_rate, 
			ChannelLayout.Layout in_ch_layout,
			Sample.Format in_sample_fmt,
			int in_sample_rate,
			int log_offset,
			void *log_ctx
		){
			_alloc_set_opts(null,
				out_ch_layout, out_sample_fmt, out_sample_rate,
				in_ch_layout, in_sample_fmt, in_sample_rate, 
				log_offset, log_ctx
			);
		}
		
		[CCode(cname = "swr_convert")]
		public int convert(
			uint8 ** out,
			int out_count,
			uint8 ** in,
			int in_count
		);
		
		[CCode(cname = "swr_next_pts")]
		public int64 next_pts(int64 pts);
		
		[CCode(cname = "swr_set_compensation")]
		public int set_compensation(int sample_delta, int compensation_distance);
		
		[CCode(cname = "swr_set_channel_mapping")]
		public int set_channel_mapping([CCode(array_length = false)] int[] channel_map);
		
		[CCode(cname = "swr_build_matrix")]
		public static int build_matrix(uint64 in_layout, uint64 out_layout,
			double center_mix_level, double surround_mix_level, double lfe_mix_level,
			double rematrix_maxval, double rematrix_volume,
			[CCode (array_length = false)]double[] matrix, int stride,
			Av.Util.ChannelLayout.MatrixEncoding matrix_encoding, void *log_ctx);
			
		[CCode(cname = "swr_set_matrix")]
		public static int set_matrix([CCode(array_length = false)] double[] matrix, int stride);
		
		[CCode(cname = "swr_drop_output")]
		public int drop_output(int count);
		
		[CCode(cname = "swr_inject_silence")]
		public int inject_silence(int count);
		
		[CCode(cname = "swr_get_delay")]
		public int64 get_delay(int64 base);
		
		[CCode(cname = "swr_get_out_samples")]
		public int get_out_samples(int in_nb_samples);
		
		[CCode(cname = "swr_convert_frame")]
		public int convert_frame(Av.Util.Frame output, Av.Util.Frame input);
		
		[CCode(cname = "swr_config_frame")]
		public int config_frame(Av.Util.Frame output, Av.Util.Frame input);
	}
}
