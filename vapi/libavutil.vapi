namespace Av.Util
{
    [CCode (cname = "AV_TIME_BASE")]
    public const int64 TIME_BASE;

    [CCode (cname = "AV_TIME_BASE_Q")]
    public const Rational TIME_BASE_Q;

    [CCode (cname = "int", cprefix = "AVERROR_", cheader_filename = "libavutil/error.h")]
    public enum Error
    {
        BSF_NOT_FOUND,
        BUG,
        TOO_SMALL,
        NOT_FOUND,
        DEMUXER_NOT_FOUND,
        ENCODER_NOT_FOUND,
        EOF,
        EXIT,
        EXTERNAL,
        FILTER_NOT_FOUND,
        INVALIDDATA,
        MUXER_NOT_FOUND,
        OPTION_NOT_FOUND,
        PATCHWELCOME,
        PROTOCOL_NOT_FOUND,
        STREAM_NOT_FOUND,
        BUG2,
        UNKNOWN,
        EXPERIMENTAL,
        INPUT_CHANGED,
        OUTPUT_CHANGED,
        HTTP_BAD_REQUEST,
        HTTP_UNAUTHORIZED,
        HTTP_FORBIDDEN,
        HTTP_NOT_FOUND,
        HTTP_OTHER_4XX,
        HTTP_SERVER_ERROR;

        [CCode (cname = "AVERROR")]
        public static Error from_posix (int errno);

        [CCode (cname = "AVUNERROR")]
        public int to_posix ();
    }

    [CCode (cheader_filename = "libavutil/mathematics.h")]
    namespace Mathematics
    {
        [CCode (cname = "M_E")]
        public const double E;
        [CCode (cname = "M_LN2")]
        public const double LN2;
        [CCode (cname = "M_LN10")]
        public const double LN10;
        [CCode (cname = "M_LOG2_10")]
        public const double LOG2_10;
        [CCode (cname = "M_PHI")]
        public const double PHI;
        [CCode (cname = "M_PI")]
        public const double PI;
        [CCode (cname = "M_PI_2")]
        public const double PI_2;
        [CCode (cname = "M_SQRT1_2")]
        public const double SQRT1_2;
        [CCode (cname = "M_SQRT2")]
        public const double SQRT2;
        [CCode (cname = "NAN")]
        public const double NAN;
        [CCode (cname = "INFINITY")]
        public const double INFINITY;

        [CCode (cname = "enum AVRounding", cprefix = "AV_ROUND_")]
        public enum Rounding
        {
            ZERO,
            INF,
            DOWN,
            UP,
            NEAR_INF,
            PASS_MINMAX
        }

        [CCode (cname = "av_gcd")]
        public static int64 gcd(int64 a, int64 b);
        [CCode (cname = "av_rescale")]
        public static int64 rescale(int64 a, int64 b, int64 c);
        [CCode (cname = "av_rescale_rnd")]
        public static int64 rescale_rnd(int64 a, int64 b, int64 c, Rounding r);
        [CCode (cname = "av_rescale_q")]
        public static int64 rescale_q(int64 a, Rational bq, Rational cq);
        [CCode (cname = "av_rescale_q_rnd")]
        public static int64 rescale_q_rnd(int64 a, Rational bq, Rational cq, Rounding r);
        [CCode (cname = "av_compare_ts")]
        public static int compare_ts(int64 ts_a, Rational tb_a, int64 ts_b, Rational tb_b);
        [CCode (cname = "av_compare_mod")]
        public static int64 compare_mod(uint64 a, uint64 b, uint64 mod);
        [CCode (cname = "av_rescale_delta")]
        public int64 rescale_delta(Rational in_tb, int64 in_ts,  Rational fs_tb, int duration, out int64 last, Rational out_tb);
        [CCode (cname = "av_add_stable")]
        public int64 add_stable(Rational ts_tb, int64 ts, Rational inc_tb, int64 inc);
    }

    [SimpleType, CCode (cname = "AVRational", cheader_filename = "libavutil/rational.h")]
    public struct Rational
    {
        public int num;
        public int den;

        [CCode (cname = "av_make_q")]
        public Rational (int num, int den);
        [CCode (cname = "av_cmp_q")]
        public int cmp_q (Rational other);
        [CCode (cname = "av_q2d")]
        public double q2d ();
        [CCode (cname = "av_reduce")]
        public static int reduce(out int dst_num, out int dst_den, int64 num, int64 den, int64 max);
        [CCode (cname = "av_mul_q")]
        public Rational mul_q(Rational c);
        [CCode (cname = "av_div_q")]
        public Rational div_q(Rational c);
        [CCode (cname = "av_add_q")]
        public Rational add_q(Rational c);
        [CCode (cname = "av_sub_q")]
        public Rational sub_q(Rational c);
        [CCode (cname = "av_inv_q")]
        public Rational inv_q();
        [CCode (cname = "av_d2q")]
        public static Rational d2q(double d, int max);
        [CCode (cname = "av_nearer_q")]
        public int nearer_q(Rational q1, Rational q2);
        [CCode (cname = "av_find_nearest_q_idx")]
        public int find_nearest_q_idx([CCode (array_length = false)]Rational[] q_list);
        [CCode (cname = "av_q2intfloat")]
        public uint32 q2intfloat();
    }

    [Flags, CCode (cname = "int", cprefix = "AV_DICT_", cheader_filename = "libavutil/dict.h")]
    public enum DictionaryFlags
    {
        MATCH_CASE,
        IGNORE_SUFFIX,
        DONT_STRDUP_KEY,
        DONT_STRDUP_VAL,
        DONT_OVERWRITE,
        APPEND,
        MULTIKEY
    }

    [Compact, CCode (cname = "AVDictionaryEntry", free_function = "av_free", cheader_filename = "libavutil/dict.h")]
    public class DictionaryEntry
    {
        public string key;
        public string @value;
    }

    [Compact, CCode (cname = "AVDictionary", free_function = "av_dict_free", free_function_address_of = true, cheader_filename = "libavutil/dict.h")]
    public class Dictionary
    {
        public int count {
            [CCode (cname = "av_dict_count")]
            get;
        }

        [CCode (cname = "av_dict_get")]
        public unowned DictionaryEntry? @get (string key, DictionaryEntry? prev, DictionaryFlags flags = (DictionaryFlags)0);
        [CCode (cname = "av_dict_set")]
        public static int @set(out Dictionary pm, string key, string @value, DictionaryFlags flags = (DictionaryFlags)0);
        [CCode (cname = "av_dict_set_int")]
        public static int set_int(out Dictionary pm, string key, int64 @value, DictionaryFlags flags = (DictionaryFlags)0);
        [CCode (cname = "av_dict_parse_string")]
        public static int parse_string(out Dictionary pm, string str, string key_val_sep, string pairs_sep, DictionaryFlags flags = (DictionaryFlags)0);
        [CCode (cname = "av_dict_copy")]
        public static int copy(out Dictionary dst, Dictionary src, DictionaryFlags flags = (DictionaryFlags)0);
        [CCode (cname = "av_dict_get_string")]
        public int get_string(out string buffer, char key_val_sep, char pairs_sep);
    }

    [CCode (cname = "enum AVMediaType", cprefix = "AVMEDIA_TYPE_", cheader_filename = "libavutil/avutil.h")]
    public enum MediaType
    {
        UNKNOWN,
        VIDEO,
        AUDIO,
        DATA,
        SUBTITLE,
        ATTACHMENT;

        [CCode (cname = "av_get_media_type_string")]
        public unowned string to_string ();
    }

    [CCode (cname = "enum AVColorRange", cprefix = "AVCOL_RANGE_", cheader_filename = "libavutil/pixfmt.h")]
    public enum ColorRange
    {
        UNSPECIFIED,
        MPEG,
        JPEG
    }

    [CCode (cname = "enum AVColorPrimaries", cprefix = "AVCOL_PRI_", cheader_filename = "libavutil/pixfmt.h")]
    public enum ColorPrimaries
    {
        RESERVED0,
        BT709,
        UNSPECIFIED,
        RESERVED,
        BT470M,
        BT470BG,
        SMPTE170M,
        SMPTE240M,
        FILM,
        BT2020,
        SMPTEST428_1
    }

    [CCode (cname = "enum AVColorTransferCharacteristic", cprefix = "AVCOL_TRC_", cheader_filename = "libavutil/pixfmt.h")]
    public enum ColorTransferCharacteristic
    {
        RESERVED0,
        BT709,
        UNSPECIFIED,
        RESERVED,
        GAMMA22,
        GAMMA28,
        SMPTE170M,
        SMPTE240M,
        LINEAR,
        LOG,
        LOG_SQRT,
        IEC61966_2_4,
        BT1361_ECG,
        IEC61966_2_1,
        BT2020_10,
        BT2020_12,
        SMPTEST2084,
        SMPTEST428_1,
        ARIB_STD_B67
    }

    [CCode (cname = "enum AVColorSpace", cprefix = "AVCOL_SPC_", cheader_filename = "libavutil/pixfmt.h")]
    public enum ColorSpace
    {
        RGB,
        BT709,
        UNSPECIFIED,
        RESERVED,
        FCC,
        BT470BG,
        SMPTE170M,
        SMPTE240M,
        YCOCG,
        BT2020_NCL,
        BT2020_CL
    }

    [CCode (cname = "enum AVChromaLocation", cprefix = "AVCHROMA_LOC_", cheader_filename = "libavutil/pixfmt.h")]
    public enum ChromaLocation
    {
        UNSPECIFIED,
        LEFT,
        CENTER,
        TOPLEFT,
        TOP,
        BOTTOMLEFT,
        BOTTOM
    }

    [CCode (cheader_filename = "libavutil/samplefmt.h")]
    namespace Sample
    {
        [CCode (cname = "enum AVSampleFormat", cprefix = "AV_SAMPLE_FMT_")]
        public enum Format
        {
            NONE,
            U8,
            S16,
            S32,
            FLT,
            DBL,
            U8P,
            S16P,
            S32P,
            FLTP,
            DBLP;

            [CCode (cname = "av_get_sample_fmt_name")]
            public unowned string to_string ();

            [CCode (cname = "av_get_sample_fmt")]
            public static Format from_string (string name);

            [CCode (cname = "av_sample_fmt_is_planar")]
            public bool is_planar ();

            [CCode (cname = "av_get_bytes_per_sample")]
            public int get_bytes_per_sample ();

            [CCode (instance_pos = 3.1, cname = "av_samples_get_buffer_size")]
            public int get_buffer_size (out int? linesize, int nb_channels, int nb_samples, bool align);
        }
    }

    [CCode (cname = "enum AVPixelFormat", cprefix = "AV_PIX_FMT_", cheader_filename = "libavutil/pixfmt.h")]
    public enum PixelFormat
    {
        NONE,
        YUV420P,
        YUYV422,
        RGB24,
        BGR24,
        YUV422P,
        YUV444P,
        YUV410P,
        YUV411P,
        GRAY8,
        MONOWHITE,
        MONOBLACK,
        PAL8,
        YUVJ420P,
        YUVJ422P,
        YUVJ444P,
        XVMC_MPEG2_MC,
        XVMC_MPEG2_IDCT,
        UYVY422,
        UYYVYY411,
        BGR8,
        BGR4,
        BGR4_BYTE,
        RGB8,
        RGB4,
        RGB4_BYTE,
        NV12,
        NV21,
        ARGB,
        RGBA,
        ABGR,
        BGRA,
        GRAY16BE,
        GRAY16LE,
        YUV440P,
        YUVJ440P,
        YUVA420P,
        VDPAU_H264,
        VDPAU_MPEG1,
        VDPAU_MPEG2,
        VDPAU_WMV3,
        VDPAU_VC1,
        RGB48BE,
        RGB48LE,
        RGB565BE,
        RGB565LE,
        RGB555BE,
        RGB555LE,
        BGR565BE,
        BGR565LE,
        BGR555BE,
        BGR555LE,
        VAAPI_MOCO,
        VAAPI_IDCT,
        VAAPI_VLD,
        VAAPI,
        YUV420P16LE,
        YUV420P16BE,
        YUV422P16LE,
        YUV422P16BE,
        YUV444P16LE,
        YUV444P16BE,
        VDPAU_MPEG4,
        DXVA2_VLD,
        RGB444LE,
        RGB444BE,
        BGR444LE,
        BGR444BE,
        YA8,
        Y400A,
        GRAY8A,
        BGR48BE,
        BGR48LE,
        YUV420P9BE,
        YUV420P9LE,
        YUV420P10BE,
        YUV420P10LE,
        YUV422P10BE,
        YUV422P10LE,
        YUV444P9BE,
        YUV444P9LE,
        YUV444P10BE,
        YUV444P10LE,
        YUV422P9BE,
        YUV422P9LE,
        VDA_VLD,
        GBRP,
        GBRP9BE,
        GBRP9LE,
        GBRP10BE,
        GBRP10LE,
        GBRP16BE,
        GBRP16LE,
        YUVA422P,
        YUVA444P,
        YUVA420P9BE,
        YUVA420P9LE,
        YUVA422P9BE,
        YUVA422P9LE,
        YUVA444P9BE,
        YUVA444P9LE,
        YUVA420P10BE,
        YUVA420P10LE,
        YUVA422P10BE,
        YUVA422P10LE,
        YUVA444P10BE,
        YUVA444P10LE,
        YUVA420P16BE,
        YUVA420P16LE,
        YUVA422P16BE,
        YUVA422P16LE,
        YUVA444P16BE,
        YUVA444P16LE,
        VDPAU,
        XYZ12LE,
        XYZ12BE,
        NV16,
        NV20LE,
        NV20BE,
        RGBA64BE,
        RGBA64LE,
        BGRA64BE,
        BGRA64LE,
        YVYU422,
        VDA,
        YA16BE,
        YA16LE,
        GBRAP,
        GBRAP16BE,
        GBRAP16LE,
        QSV,
        MMAL,
        D3D11VA_VLD,
        CUDA,
        0RGB,
        RGB0,
        0BGR,
        BGR0,
        YUV420P12BE,
        YUV420P12LE,
        YUV420P14BE,
        YUV420P14LE,
        YUV422P12BE,
        YUV422P12LE,
        YUV422P14BE,
        YUV422P14LE,
        YUV444P12BE,
        YUV444P12LE,
        YUV444P14BE,
        YUV444P14LE,
        GBRP12BE,
        GBRP12LE,
        GBRP14BE,
        GBRP14LE,
        YUVJ411P,
        BAYER_BGGR8,
        BAYER_RGGB8,
        BAYER_GBRG8,
        BAYER_GRBG8,
        BAYER_BGGR16LE,
        BAYER_BGGR16BE,
        BAYER_RGGB16LE,
        BAYER_RGGB16BE,
        BAYER_GBRG16LE,
        BAYER_GBRG16BE,
        BAYER_GRBG16LE,
        BAYER_GRBG16BE,
        XVMC,
        YUV440P10LE,
        YUV440P10BE,
        YUV440P12LE,
        YUV440P12BE,
        AYUV64LE,
        AYUV64BE,
        VIDEOTOOLBOX,
        P010LE,
        P010BE,
        GBRAP12BE,
        GBRAP12LE,
        GBRAP10BE,
        GBRAP10LE
    }

    [Compact, CCode (cname = "AVBuffer", free_function = "", cheader_filename = "libavutil/buffer.h")]
    public class Buffer
    {
    }

    [Compact, CCode (cname = "AVBufferRef", ref_function = "av_buffer_ref", unref_function = "av_util_buffer_ref_unref", cheader_filename = "libavutil/buffer.h")]
    public class BufferRef
    {
        public Buffer buffer;
        [CCode (array_length_cname = "size")]
        public uint8[] data;

        public int ref_count {
            [CCode (cname = "av_buffer_get_ref_count")]
            get;
        }

        public bool is_writable {
            [CCode (cname = "av_buffer_is_writable")]
            get;
        }

        [CCode (cname = "av_buffer_alloc")]
        public BufferRef (int size);

        [CCode (cname = "av_buffer_ref")]
        public BufferRef @ref ();

        [CCode (cname = "av_buffer_unref")]
        static void _unref (ref unowned BufferRef buffer);
        public void unref ()
        {
            _unref (ref this);
        }
    }

    [CCode (cname = "enum AVPictureType", cprefix = "AV_PICTURE_TYPE_", cheader_filename = "libavutil/avutil.h")]
    public enum PictureType
    {
        NONE,
        I,
        P,
        B,
        S,
        SI,
        SP,
        BI
    }

    [CCode (cheader_filename = "libavutil/channel_layout.h")]
    namespace ChannelLayout
    {
        [Flags, CCode (cname = "gint64", cprefix = "AV_CH_F")]
        public enum Flags
        {
            FRONT_LEFT,
            FRONT_RIGHT,
            FRONT_CENTER,
            LOW_FREQUENCY,
            BACK_LEFT,
            BACK_RIGHT,
            FRONT_LEFT_OF_CENTER,
            FRONT_RIGHT_OF_CENTER,
            BACK_CENTER,
            SIDE_LEFT,
            SIDE_RIGHT,
            TOP_CENTER,
            TOP_FRONT_LEFT,
            TOP_FRONT_CENTER,
            TOP_FRONT_RIGHT,
            TOP_BACK_LEFT,
            TOP_BACK_CENTER,
            TOP_BACK_RIGHT,
            STEREO_LEFT,
            STEREO_RIGHT,
            WIDE_LEFT,
            WIDE_RIGHT,
            SURROUND_DIRECT_LEFT,
            SURROUND_DIRECT_RIGHT,
            LOW_FREQUENCY_2,
            LAYOUT_NATIVE
        }

        [CCode (cname = "gint64", cprefix = "AV_CH_LAYOUT_")]
        public enum Mask
        {
            MONO,
            STEREO,
            2POINT1,
            2_1,
            SURROUND,
            3POINT1,
            4POINT0,
            4POINT1,
            2_2,
            QUAD,
            5POINT0,
            5POINT1,
            5POINT0_BACK,
            5POINT1_BACK,
            6POINT0,
            6POINT0_FRONT,
            HEXAGONAL,
            6POINT1,
            6POINT1_BACK,
            6POINT1_FRONT,
            7POINT0,
            7POINT0_FRONT,
            7POINT1,
            7POINT1_WIDE,
            7POINT1_WIDE_BACK,
            OCTAGONAL,
            HEXADECAGONAL,
            STEREO_DOWNMIX
        }

        [CCode (cname = "enum AVMatrixEncoding", cprefix = "AV_MATRIX_ENCODING_")]
        public enum MatrixEncoding
        {
            NONE,
            DOLBY,
            DPLII,
            DPLIIX,
            DPLIIZ,
            DOLBYEX,
            DOLBYHEADPHONE
        }
    }

    [CCode (cname = "enum AVFrameSideDataType", cprefix = "AV_FRAME_DATA_", cheader_filename = "libavutil/frame.h")]
    public enum FrameSideDataType
    {
        PANSCAN,
        A53_CC,
        STEREO3D,
        MATRIXENCODING,
        DOWNMIX_INFO,
        REPLAYGAIN,
        DISPLAYMATRIX,
        AFD,
        MOTION_VECTORS,
        SKIP_SAMPLES,
        AUDIO_SERVICE_TYPE,
        MASTERING_DISPLAY_METADATA,
        GOP_TIMECODE
    }

    [Compact, CCode (cname = "AVFrameSideData", free_function = "", cheader_filename = "libavutil/frame.h")]
    public class FrameSideData
    {
        public FrameSideDataType    type;
        [CCode (array_length_cname = "size")]
        public uint8[]              data;
        public Dictionary           metadata;
        public BufferRef            buf;

        [CCode (cname = "av_frame_side_data_name")]
        public unowned string to_string ();
    }

    [Compact, CCode (cname = "AVFrame", free_function = "av_frame_free", free_function_address_of = true, cheader_filename = "libavutil/frame.h")]
    public class Frame
    {
        [Flags, CCode (cname = "int", cprefix = "AV_FRAME_FLAG_")]
        public enum Flag
        {
            CORRUPT
        }

        [Flags, CCode (cname = "int", cprefix = "FF_DECODE_ERROR_")]
        public enum DecodeError
        {
            INVALID_BITSTREAM,
            MISSING_REFERENCE
        }

        public uint8*           data[8];
        public int              linesize[8];
        [CCode (array_length = false)]
        public uint8[,]         extended_data;
        public int              width;
        public int              height;
        public int              nb_samples;
        public Sample.Format    format;
        public bool             key_frame;
        public PictureType      pict_type;
        public Rational         sample_aspect_ratio;
        public int64            pts;
        public int64            pkt_pts;
        public int64            pkt_dts;
        public int              coded_picture_number;
        public int              display_picture_number;
        public int              quality;
        public int              repeat_pict;
        public int              interlaced_frame;
        public int              top_field_first;
        public bool             palette_has_changed;
        public int64            reordered_opaque;
        public BufferRef        buf[8];
        [CCode (array_length_cname = "nb_extended_buf")]
        public BufferRef[]      extended_buf;
        [CCode (array_length_cname = "nb_side_data")]
        public FrameSideData[]  side_data;
        public Flag             flags;
        public ColorPrimaries   color_primaries;
        public ColorTransferCharacteristic color_trc;
        public ChromaLocation   chroma_location;

        public int64 best_effort_timestamp {
            [CCode (cname = "av_frame_get_best_effort_timestamp")]
            get;
            [CCode (cname = "av_frame_set_best_effort_timestamp")]
            set;
        }

        public int64 pkt_duration {
            [CCode (cname = "av_frame_get_pkt_duration")]
            get;
            [CCode (cname = "av_frame_set_pkt_duration")]
            set;
        }

        public int64 pkt_pos {
            [CCode (cname = "av_frame_get_pkt_pos")]
            get;
            [CCode (cname = "av_frame_set_pkt_pos")]
            set;
        }

        public ChannelLayout.Mask channel_layout {
            [CCode (cname = "av_frame_get_channel_layout")]
            get;
            [CCode (cname = "av_frame_set_channel_layout")]
            set;
        }

        public int channels {
            [CCode (cname = "av_frame_get_channels")]
            get;
            [CCode (cname = "av_frame_set_channels")]
            set;
        }

        public int sample_rate {
            [CCode (cname = "av_frame_get_sample_rate")]
            get;
            [CCode (cname = "av_frame_set_sample_rate")]
            set;
        }

        public unowned Dictionary metadata {
            [CCode (cname = "av_frame_get_metadata")]
            get;
            [CCode (cname = "av_frame_set_metadata")]
            set;
        }

        public DecodeError error_flags {
            [CCode (cname = "av_frame_get_decode_error_flags")]
            get;
            [CCode (cname = "av_frame_set_decode_error_flags")]
            set;
        }

        public int pkt_size {
            [CCode (cname = "av_frame_get_pkt_size")]
            get;
            [CCode (cname = "av_frame_set_pkt_size")]
            set;
        }

        public ColorSpace colorspace {
            [CCode (cname = "av_frame_get_colorspace")]
            get;
            [CCode (cname = "av_frame_set_colorspace")]
            set;
        }

        public ColorRange color_range {
            [CCode (cname = "av_frame_get_color_range")]
            get;
            [CCode (cname = "av_frame_set_color_range")]
            set;
        }

        public bool is_writable {
            [CCode (cname = "av_frame_is_writable")]
            get;
        }

        [CCode (cname = "av_frame_alloc")]
        public Frame ();

        [CCode (cname = "av_frame_get_buffer")]
        public int get_buffer (bool align);

        [CCode (cname = "av_frame_make_writable")]
        public int make_writable ();

        [CCode (cname = "av_frame_get_plane_buffer")]
        public unowned BufferRef get_plane_buffer (int plane);
    }

    [CCode (cheader_filename = "libavutil/opt.h")]
    namespace Options
    {
        [Compact, CCode (cname = "AVOption")]
        public class Option
        {
            [CCode (cname = "AVOptionType", cprefix = "AV_OPT_TYPE_")]
            public enum Type
            {
                FLAGS,
                INT,
                INT64,
                DOUBLE,
                FLOAT,
                STRING,
                RATIONAL,
                BINARY,
                DICT,
                CONST,
                IMAGE_SIZE,
                PIXEL_FMT,
                SAMPLE_FMT,
                VIDEO_RATE,
                DURATION,
                COLOR,
                CHANNEL_LAYOUT,
                BOOL
            }

            [Flags, CCode (cname = "int", cprefix = "AV_OPT_FLAG_")]
            public enum Flags
            {
                ENCODING_PARAM,
                DECODING_PARAM,
                METADATA,
                AUDIO_PARAM,
                VIDEO_PARAM,
                SUBTITLE_PARAM,
                EXPORT,
                READONLY,
                FILTERING_PARAM
            }

            public string       name;
            public string       help;
            public int          offset;
            public Type         type;
            [CCode (cname = "default_val.i64")]
            public int64        default_val_i64;
            [CCode (cname = "default_val.dbl")]
            public double       default_val_dbl;
            [CCode (cname = "default_val.str")]
            public string       default_val_str;
            [CCode (cname = "default_val.q")]
            public Rational     default_val_q;
            public double       min;
            public double       max;
            public Flags        sflags;
            public string       unit;
        }

        [Flags, CCode (cname = "int", cprefix = "AV_OPT_")]
        public enum SearchFlags
        {
            SEARCH_CHILDREN,
            SEARCH_FAKE_OBJ,
            ALLOW_NULL,
            MULTI_COMPONENT_RANGE
        }

        [CCode (cname = "av_opt_find")]
        public static unowned Option? find(void *obj, string name, string? unit, Option.Flags opt_flags, SearchFlags search_flags);

        [CCode (cname = "av_opt_set")]
        public static int @set (void *obj, string name, string val, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_int")]
        public static int set_int (void *obj, string name, int64 val, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_double")]
        public static int set_double (void *obj, string name, double val, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_q")]
        public static int set_q (void *obj, string name, Rational val, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_bin")]
        public static int set_bin (void *obj, string name, uint8[] val, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_image_size")]
        public static int set_image_size (void *obj, string name, int w, int h, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_pixel_fmt")]
        public static int set_pixel_fmt (void *obj, string name, PixelFormat fmt, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_sample_fmt")]
        public static int set_sample_fmt (void *obj, string name, Sample.Format fmt, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_video_rate")]
        public static int set_video_rate (void *obj, string name, Rational val, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_channel_layout")]
        public static int set_channel_layout (void *obj, string name, ChannelLayout.Mask ch_layout, SearchFlags search_flags = (SearchFlags)0);
        [CCode (cname = "av_opt_set_dict_val")]
        public static int set_dict_val(void *obj, string name, Dictionary val, SearchFlags search_flags = (SearchFlags)0);

        [CCode (cname = "av_opt_get")]
        public static int @get (void *obj, string name, SearchFlags search_flags, out string out_val);
        [CCode (cname = "av_opt_get_int")]
        public static int get_int (void *obj, string name, SearchFlags search_flags, out int64 out_val);
        [CCode (cname = "av_opt_get_double")]
        public static int get_double (void *obj, string name, SearchFlags search_flags, out double out_val);
        [CCode (cname = "av_opt_get_q")]
        public static int get_q (void *obj, string name, SearchFlags search_flags, out Rational out_val);
        [CCode (cname = "av_opt_get_image_size")]
        public static int get_image_size (void *obj, string name, SearchFlags search_flags, out int w_out, out int h_out);
        [CCode (cname = "av_opt_get_pixel_fmt")]
        public static int get_pixel_fmt (void *obj, string name, SearchFlags search_flags, out PixelFormat out_fmt);
        [CCode (cname = "av_opt_get_sample_fmt")]
        public static int get_sample_fmt (void *obj, string name, SearchFlags search_flags, out Sample.Format out_fmt);
        [CCode (cname = "av_opt_get_video_rate")]
        public static int get_video_rate (void *obj, string name, SearchFlags search_flags, out Rational out_val);
        [CCode (cname = "av_opt_get_channel_layout")]
        public static int get_channel_layout (void *obj, string name, SearchFlags search_flags, out ChannelLayout.Mask out_ch_layout);
        [CCode (cname = "av_opt_get_dict_val")]
        public static int get_dict_val (void *obj, string name, SearchFlags search_flags, out Dictionary out_val);
    }
}
