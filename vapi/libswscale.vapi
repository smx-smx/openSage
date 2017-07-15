[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "libswscale/swscale.h")]
namespace Sw.Scale {
	[CCode(cname = "sws_isSupportedInput")]
	public bool supported_input(Av.Util.PixelFormat pix_fmt);

	[CCode(cname = "sws_isSupportedOutput")]
	public bool supported_output(Av.Util.PixelFormat pix_fmt);

	[CCode(cname = "sws_isSupportedEndiannessConversion")]
	public bool supported_endianess_conversion(Av.Util.PixelFormat pix_fmt);

	[CCode(cname = "sws_convertPalette8ToPacked32")]
	public void convert_palette_8_to_packed_32(uint8[] src, uint8[] dst, int num_pixels, uint8[] palette);

	[CCode(cname = "sws_convertPalette8ToPacked24")]
	public void convert_palette_8_to_packed_24(uint8[] src, uint8[] dst, int num_pixels, uint8[] palette);

	[CCode(cname = "sws_getCoefficients")]
	public int[] get_coefficients(ColorSpace colorspace);

	[CCode(cname = "int", cprefix = "SWS_CS_")]
	public enum ColorSpace {
		ITU709 = 1,
		FCC = 4,
		ITU601 = 5,
		ITU624 = 5,
		SMPTE170M = 5,
		SMPTE240M = 7,
		DEFAULT = 5,
		BT2020 = 9
	}

	[Flags, CCode (cname = "int", cprefix = "SWS_")]
	public enum ScaleFlags {
		FAST_BILINEAR = 1,
		BILINEAR = 2,
		BICUBIC = 4,
		X = 8,
		POINT = 0x10,
		AREA = 0x20,
		BICUBLIN = 0x40,
		GAUSS = 0x80,
		SINC = 0x100,
		LANCZOS = 0x200,
		SPLINE = 0x400,
		SRC_V_CHR_DROP_MASK = 0x30000,
		SRC_V_CHR_DROP_SHIFT = 16,
		PARAM_DEFAULT = 123456,
		PRINT_INFO = 0x1000,
		FULL_CHR_H_INT = 0x2000,
		FULL_CHR_H_INP = 0x4000,
		DIRECT_BGR = 0x8000,
		ACCURATE_RND = 0x40000,
		BITEXACT = 0x80000,
		ERROR_DIFFUSION = 0x800000,

		MAX_REDUCE_CUTOFF = 0.002,
	}

	[Compact, CCode(cname = "SwsVector", free_function = "sws_freeVec")]
	public class Vector {
		[CCode (array_length_cname = "length")]
		public double[] coeff;

		[CCode(cname = "sws_allocVec")]
		public Vector(int length);

		[CCode(cname = "sws_scaleVec")]
		public void scale(double scalar);

		[CCode(cname = "sws_normalizeVec")]
		public void normalize(double height);

		[CCode(cname = "sws_getGaussianVec")]
		public static Vector get_gaussian_vec(double variance, double quality);
	}

	[Compact, CCode(cname = "SwsFilter", free_function = "sws_freeFilter")]
	public struct Filter {
		public Vector lumH;
		public Vector lumV;
		public Vector chrH;
		public Vector chrV;
	}

	[Compact, CCode(cname = "struct SwsContext", cprefix = "sws_", free_function = "sws_freeContext")]
	public class Context {
		[CCode(cname = "sws_alloc_context")]
		public Context();

		[CCode(cname = "sws_init_context")]
		public int init();

		[CCode(cname = "sws_getContext")]
		public static Context get_context(
						int srcW, int srcH, Av.Util.PixelFormat srcFormat,
                        int dstW, int dstH, Av.Util.PixelFormat dstFormat,
						ScaleFlags flags,
						Filter? srcFilter,
						Filter? dstFilter,
						double *param);
								  
		[CCode(cname = "sws_scale")]
		public int scale(
			uint8 **srcSlice, int *srcStride,
			int srcSlideY, int srcSliceH,
			uint8 **dst, int *dstStride);

		[CCode(cname = "sws_setColorspaceDetails")]
		public int set_colorspace_details(int inv_table[4], int srcRange, int table[4],
							int dstRange, int brightness, int contrast, int saturation);

		[CCode(cname = "sws_getColorspaceDetails")]
		public int get_colorspace_details(out int[] inv_table, int[] srcRange, out int[] table,
							int[] dstRange, int[] brightness, int[] contrast, int[] saturation);
		
		[CCode(cname = "sws_getCachedContext")]
		public static Context get_cached_context(int srcW, int srcH, Av.Util.PixelFormat srcFormat,
                                        int dstW, int dstH, Av.Util.PixelFormat dstFormat,
                                        int flags, Filter srcFilter,
                                        Filter dstFilter, double[]? param);
	}
}
