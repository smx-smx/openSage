namespace Av.Codec
{
    [CCode (cname = "avcodec_register_all")]
    public void register_all ();

    [CCode (cname = "enum AVCodecID", cprefix = "AV_CODEC_ID_", cheader_filename = "libavcodec/avcodec.h")]
    public enum ID
    {
        NONE,
        MPEG1VIDEO,
        MPEG2VIDEO,
        H261,
        H263,
        RV10,
        RV20,
        MJPEG,
        MJPEGB,
        LJPEG,
        SP5X,
        JPEGLS,
        MPEG4,
        RAWVIDEO,
        MSMPEG4V1,
        MSMPEG4V2,
        MSMPEG4V3,
        WMV1,
        WMV2,
        H263P,
        H263I,
        FLV1,
        SVQ1,
        SVQ3,
        DVVIDEO,
        HUFFYUV,
        CYUV,
        H264,
        INDEO3,
        VP3,
        THEORA,
        ASV1,
        ASV2,
        FFV1,
        4XM,
        VCR1,
        CLJR,
        MDEC,
        ROQ,
        INTERPLAY_VIDEO,
        XAN_WC3,
        XAN_WC4,
        RPZA,
        CINEPAK,
        WS_VQA,
        MSRLE,
        MSVIDEO1,
        IDCIN,
        8BPS,
        SMC,
        FLIC,
        TRUEMOTION1,
        VMDVIDEO,
        MSZH,
        ZLIB,
        QTRLE,
        TSCC,
        ULTI,
        QDRAW,
        VIXL,
        QPEG,
        PNG,
        PPM,
        PBM,
        PGM,
        PGMYUV,
        PAM,
        FFVHUFF,
        RV30,
        RV40,
        VC1,
        WMV3,
        LOCO,
        WNV1,
        AASC,
        INDEO2,
        FRAPS,
        TRUEMOTION2,
        BMP,
        CSCD,
        MMVIDEO,
        ZMBV,
        AVS,
        SMACKVIDEO,
        NUV,
        KMVC,
        FLASHSV,
        CAVS,
        JPEG2000,
        VMNC,
        VP5,
        VP6,
        VP6F,
        TARGA,
        DSICINVIDEO,
        TIERTEXSEQVIDEO,
        TIFF,
        GIF,
        DXA,
        DNXHD,
        THP,
        SGI,
        C93,
        BETHSOFTVID,
        PTX,
        TXD,
        VP6A,
        AMV,
        VB,
        PCX,
        SUNRAST,
        INDEO4,
        INDEO5,
        MIMIC,
        RL2,
        ESCAPE124,
        DIRAC,
        BFI,
        CMV,
        MOTIONPIXELS,
        TGV,
        TGQ,
        TQI,
        AURA,
        AURA2,
        V210X,
        TMV,
        V210,
        DPX,
        MAD,
        FRWU,
        FLASHSV2,
        CDGRAPHICS,
        R210,
        ANM,
        BINKVIDEO,
        IFF_ILBM,
        IFF_BYTERUN1,
        KGV1,
        YOP,
        VP8,
        PICTOR,
        ANSI,
        A64_MULTI,
        A64_MULTI5,
        R10K,
        MXPEG,
        LAGARITH,
        PRORES,
        JV,
        DFA,
        WMV3IMAGE,
        VC1IMAGE,
        UTVIDEO,
        BMV_VIDEO,
        VBLE,
        DXTORY,
        V410,
        XWD,
        CDXL,
        XBM,
        ZEROCODEC,
        MSS1,
        MSA1,
        TSCC2,
        MTS2,
        CLLC,
        MSS2,
        VP9,
        AIC,
        ESCAPE130,
        G2M,
        WEBP,
        HNM4_VIDEO,
        HEVC,
        H265,
        FIC,
        ALIAS_PIX,
        BRENDER_PIX,
        PAF_VIDEO,
        EXR,
        VP7,
        SANM,
        SGIRLE,
        MVC1,
        MVC2,
        HQX,
        TDSC,
        HQ_HQA,
        HAP,
        DDS,
        DXV,
        SCREENPRESSO,
        RSCC,
        Y41P,
        AVRP,
        012V,
        AVUI,
        AYUV,
        TARGA_Y216,
        V308,
        V408,
        YUV4,
        AVRN,
        CPIA,
        XFACE,
        SNOW,
        SMVJPEG,
        APNG,
        DAALA,
        CFHD,
        TRUEMOTION2RT,
        M101,
        MAGICYUV,
        SHEERVIDEO,
        YLC,
        FIRST_AUDIO,
        PCM_S16LE,
        PCM_S16BE,
        PCM_U16LE,
        PCM_U16BE,
        PCM_S8,
        PCM_U8,
        PCM_MULAW,
        PCM_ALAW,
        PCM_S32LE,
        PCM_S32BE,
        PCM_U32LE,
        PCM_U32BE,
        PCM_S24LE,
        PCM_S24BE,
        PCM_U24LE,
        PCM_U24BE,
        PCM_S24DAUD,
        PCM_ZORK,
        PCM_S16LE_PLANAR,
        PCM_DVD,
        PCM_F32BE,
        PCM_F32LE,
        PCM_F64BE,
        PCM_F64LE,
        PCM_BLURAY,
        PCM_LXF,
        S302M,
        PCM_S8_PLANAR,
        PCM_S24LE_PLANAR,
        PCM_S32LE_PLANAR,
        PCM_S16BE_PLANAR,
        ADPCM_IMA_QT,
        ADPCM_IMA_WAV,
        ADPCM_IMA_DK3,
        ADPCM_IMA_DK4,
        ADPCM_IMA_WS,
        ADPCM_IMA_SMJPEG,
        ADPCM_MS,
        ADPCM_4XM,
        ADPCM_XA,
        ADPCM_ADX,
        ADPCM_EA,
        ADPCM_G726,
        ADPCM_CT,
        ADPCM_SWF,
        ADPCM_YAMAHA,
        ADPCM_SBPRO_4,
        ADPCM_SBPRO_3,
        ADPCM_SBPRO_2,
        ADPCM_THP,
        ADPCM_IMA_AMV,
        ADPCM_EA_R1,
        ADPCM_EA_R3,
        ADPCM_EA_R2,
        ADPCM_IMA_EA_SEAD,
        ADPCM_IMA_EA_EACS,
        ADPCM_EA_XAS,
        ADPCM_EA_MAXIS_XA,
        ADPCM_IMA_ISS,
        ADPCM_G722,
        ADPCM_IMA_APC,
        ADPCM_VIMA,
        ADPCM_AFC,
        ADPCM_IMA_OKI,
        ADPCM_DTK,
        ADPCM_IMA_RAD,
        ADPCM_G726LE,
        ADPCM_THP_LE,
        ADPCM_PSX,
        ADPCM_AICA,
        ADPCM_IMA_DAT4,
        ADPCM_MTAF,
        AMR_NB,
        AMR_WB,
        RA_144,
        RA_288,
        ROQ_DPCM,
        INTERPLAY_DPCM,
        XAN_DPCM,
        SOL_DPCM,
        SDX2_DPCM,
        MP2,
        MP3,
        AAC,
        AC3,
        DTS,
        VORBIS,
        DVAUDIO,
        WMAV1,
        WMAV2,
        MACE3,
        MACE6,
        VMDAUDIO,
        FLAC,
        MP3ADU,
        MP3ON4,
        SHORTEN,
        ALAC,
        WESTWOOD_SND1,
        GSM,
        QDM2,
        COOK,
        TRUESPEECH,
        TTA,
        SMACKAUDIO,
        QCELP,
        WAVPACK,
        DSICINAUDIO,
        IMC,
        MUSEPACK7,
        MLP,
        GSM_MS,
        ATRAC3,
        APE,
        NELLYMOSER,
        MUSEPACK8,
        SPEEX,
        WMAVOICE,
        WMAPRO,
        WMALOSSLESS,
        ATRAC3P,
        EAC3,
        SIPR,
        MP1,
        TWINVQ,
        TRUEHD,
        MP4ALS,
        ATRAC1,
        BINKAUDIO_RDFT,
        BINKAUDIO_DCT,
        AAC_LATM,
        QDMC,
        CELT,
        G723_1,
        G729,
        8SVX_EXP,
        8SVX_FIB,
        BMV_AUDIO,
        RALF,
        IAC,
        ILBC,
        OPUS,
        COMFORT_NOISE,
        TAK,
        METASOUND,
        PAF_AUDIO,
        ON2AVC,
        DSS_SP,
        FFWAVESYNTH,
        SONIC,
        SONIC_LS,
        EVRC,
        SMV,
        DSD_LSBF,
        DSD_MSBF,
        DSD_LSBF_PLANAR,
        DSD_MSBF_PLANAR,
        4GV,
        INTERPLAY_ACM,
        XMA1,
        XMA2,
        DST,
        FIRST_SUBTITLE,
        DVD_SUBTITLE,
        DVB_SUBTITLE,
        TEXT,
        XSUB,
        SSA,
        MOV_TEXT,
        HDMV_PGS_SUBTITLE,
        DVB_TELETEXT,
        SRT,
        MICRODVD,
        EIA_608,
        JACOSUB,
        SAMI,
        REALTEXT,
        STL,
        SUBVIEWER1,
        SUBVIEWER,
        SUBRIP,
        WEBVTT,
        MPL2,
        VPLAYER,
        PJS,
        ASS,
        HDMV_TEXT_SUBTITLE,
        FIRST_UNKNOWN,
        TTF,
        BINTEXT,
        XBIN,
        IDF,
        OTF,
        SMPTE_KLV,
        DVD_NAV,
        TIMED_ID3,
        BIN_DATA,
        PROBE,
        MPEG2TS,
        MPEG4SYSTEMS,
        FFMETADATA,
        WRAPPED_AVFRAME;

        [CCode (cname = "avcodec_find_decoder")]
        public unowned Codec find_decoder ();
    }

    [Flags, CCode (cname = "enum AVDiscard", cprefix = "AVDISCARD_", cheader_filename = "libavcodec/avcodec.h")]
    public enum Discard
    {
        NONE,
        DEFAULT,
        NONREF,
        BIDIR,
        NONINTRA,
        NONKEY,
        ALL
    }

    [Flags, CCode (cname = "int", cprefix = "AV_PKT_FLAG_", cheader_filename = "libavcodec/avcodec.h")]
    public enum PktFlag
    {
        KEY,
        CORRUPT
    }

    [CCode (cname = "enum AVPacketSideDataType", cprefix = "AV_PKT_DATA_", cheader_filename = "libavcodec/avcodec.h")]
    public enum PacketSideDataType
    {
        PALETTE,
        NEW_EXTRADATA,
        PARAM_CHANGE,
        H263_MB_INFO,
        REPLAYGAIN,
        DISPLAYMATRIX,
        STEREO3D,
        AUDIO_SERVICE_TYPE,
        QUALITY_STATS,
        FALLBACK_TRACK,
        CPB_PROPERTIES,
        SKIP_SAMPLES,
        JP_DUALMONO,
        STRINGS_METADATA,
        SUBTITLE_POSITION,
        MATROSKA_BLOCKADDITIONAL,
        WEBVTT_IDENTIFIER,
        WEBVTT_SETTINGS,
        METADATA_UPDATE,
        MPEGTS_STREAM_ID,
        MASTERING_DISPLAY_METADATA
    }

    [SimpleType, CCode (cname = "AVPacketSideData", cheader_filename = "libavcodec/avcodec.h")]
    public struct PacketSideData
    {
        [CCode (array_length_cname = "size")]
        public uint8[] data;
        public PacketSideDataType type;
    }

    [Compact, CCode (cname = "AVPacket", free_function = "av_packet_free", free_function_address_of = true, cheader_filename = "libavcodec/avcodec.h")]
    public class Packet
    {
        public int64   pts;
        public int64   dts;
        public uint8*  data;
        public int     size;
        public int     stream_index;
        public PktFlag flags;
        public int64   duration;
        public int64   pos;

        [CCode (cname = "av_packet_alloc")]
        public Packet ();

        [CCode (cname = "av_init_packet")]
        public void init ();

        [CCode (cname = "av_packet_unref")]
        public void unref ();
    }

    [CCode (cname = "int", cprefix = "FF_PROFILE_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFProfile
    {
        UNKNOWN,
        RESERVED,
        AAC_MAIN,
        AAC_LOW,
        AAC_SSR,
        AAC_LTP,
        AAC_HE,
        AAC_HE_V2,
        AAC_LD,
        AAC_ELD,
        MPEG2_AAC_LOW,
        MPEG2_AAC_HE,
        DTS,
        DTS_ES,
        DTS_96_24,
        DTS_HD_HRA,
        DTS_HD_MA,
        DTS_EXPRESS,
        MPEG2_422,
        MPEG2_HIGH,
        MPEG2_SS,
        MPEG2_SNR_SCALABLE,
        MPEG2_MAIN,
        MPEG2_SIMPLE,
        H264_CONSTRAINED,
        H264_INTRA,
        H264_BASELINE,
        H264_CONSTRAINED_BASELINE,
        H264_MAIN,
        H264_EXTENDED,
        H264_HIGH,
        H264_HIGH_10,
        H264_HIGH_10_INTRA,
        H264_HIGH_422,
        H264_HIGH_422_INTRA,
        H264_HIGH_444,
        H264_HIGH_444_PREDICTIVE,
        H264_HIGH_444_INTRA,
        H264_CAVLC_444,
        VC1_SIMPLE,
        VC1_MAIN,
        VC1_COMPLEX,
        VC1_ADVANCED,
        MPEG4_SIMPLE,
        MPEG4_SIMPLE_SCALABLE,
        MPEG4_CORE,
        MPEG4_MAIN,
        MPEG4_N_BIT,
        MPEG4_SCALABLE_TEXTURE,
        MPEG4_SIMPLE_FACE_ANIMATION,
        MPEG4_BASIC_ANIMATED_TEXTURE,
        MPEG4_HYBRID,
        MPEG4_ADVANCED_REAL_TIME,
        MPEG4_CORE_SCALABLE,
        MPEG4_ADVANCED_CODING,
        MPEG4_ADVANCED_CORE,
        MPEG4_ADVANCED_SCALABLE_TEXTURE,
        MPEG4_SIMPLE_STUDIO,
        MPEG4_ADVANCED_SIMPLE,
        JPEG2000_CSTREAM_RESTRICTION_0,
        JPEG2000_CSTREAM_RESTRICTION_1,
        JPEG2000_CSTREAM_NO_RESTRICTION,
        JPEG2000_DCINEMA_2K,
        JPEG2000_DCINEMA_4K,
        VP9_0,
        VP9_1,
        VP9_2,
        VP9_3,
        HEVC_MAIN,
        HEVC_MAIN_10,
        HEVC_MAIN_STILL_PICTURE,
        HEVC_REXT
    }

    [SimpleType, CCode (cname = "AVProfile", cheader_filename = "libavcodec/avcodec.h")]
    public struct Profile
    {
        FFProfile profile;
        string name;
    }

    [Flags, CCode (cname = "int", cprefix = "AV_CODEC_CAP_", cheader_filename = "libavcodec/avcodec.h")]
    public enum Cap
    {
        DRAW_HORIZ_BAND,
        DR1,
        TRUNCATED,
        DELAY,
        SMALL_LAST_FRAME,
        HWACCEL_VDPAU,
        SUBFRAMES,
        EXPERIMENTAL,
        CHANNEL_CONF,
        FRAME_THREADS,
        SLICE_THREADS,
        PARAM_CHANGE,
        AUTO_THREADS,
        VARIABLE_FRAME_SIZE,
        INTRA_ONLY,
        LOSSLESS
    }

    [CCode (cname = "enum AVFieldOrder", cprefix = "AV_FIELD_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FieldOrder
    {
        UNKNOWN,
        PROGRESSIVE,
        TT,
        BB,
        TB,
        BT,
    }

    [Compact, CCode (cname = "AVCodecParameters", free_function = "avcodec_parameters_free", cheader_filename = "libavcodec/avcodec.h")]
    public class Parameters
    {
        public Util.MediaType                   codec_type;
        public ID                               codec_id;
        public uint32                           codec_tag;
        [CCode (array_length_cname = "extradata_size")]
        public uint8[]                          extradata;
        public int                              format;
        public int64                            bit_rate;
        public int                              bits_per_coded_sample;
        public int                              bits_per_raw_sample;
        public int                              profile;
        public int                              level;
        public int                              width;
        public int                              height;
        public Util.Rational                    sample_aspect_ratio;
        public FieldOrder                       field_order;
        public Util.ColorRange                  color_range;
        public Util.ColorPrimaries              color_primaries;
        public Util.ColorTransferCharacteristic color_trc;
        public Util.ColorSpace                  color_space;
        public Util.ChromaLocation              chroma_location;
        public int                              video_delay;
        public uint64                           channel_layout;
        public int                              channels;
        public int                              sample_rate;
        public int                              block_align;
        public int                              frame_size;
        public int                              initial_padding;
        public int                              trailing_padding;
        public int                              seek_preroll;

        [CCode (cname = "avcodec_parameters_alloc")]
        public Parameters ();
    }

    [Compact, CCode (cname = "AVCodec", free_function = "", cheader_filename = "libavcodec/avcodec.h")]
    public class Codec
    {
        public string               name;
        public string               long_name;
        public Util.MediaType       type;
        public ID                   id;
        public Cap                  capabilities;
        public Util.Rational        supported_framerates;
        [CCode (array_length = false)]
        public Util.PixelFormat[]   pix_fmts;
        [CCode (array_length = false)]
        public int[]                supported_samplerates;
        [CCode (array_length = false)]
        public Util.Sample.Format[] sample_fmts;
        [CCode (array_length = false)]
        public uint64[]             channel_layouts;
        public uint8                max_lowres;
        [CCode (array_length = false)]
        public Profile[]            profiles;
    }

    [Flags, CCode (cname = "int", cprefix = "AV_CODEC_FLAG_", cheader_filename = "libavcodec/avcodec.h")]
    public enum Flag
    {
        UNALIGNED,
        QSCALE,
        4MV,
        OUTPUT_CORRUPT,
        QPEL,
        PASS1,
        PASS2,
        LOOP_FILTER,
        GRAY,
        PSNR,
        TRUNCATED,
        INTERLACED_DCT,
        LOW_DELAY,
        GLOBAL_HEADER,
        BITEXACT,
        AC_PRED,
        INTERLACED_ME,
        CLOSED_GOP
    }

    [Flags, CCode (cname = "int", cprefix = "AV_CODEC_FLAG2_", cheader_filename = "libavcodec/avcodec.h")]
    public enum Flag2
    {
        FAST,
        NO_OUTPUT,
        LOCAL_HEADER,
        DROP_FRAME_TIMECODE,
        CHUNKS,
        IGNORE_CROP,
        SHOW_ALL,
        EXPORT_MVS,
        SKIP_MANUAL,
        RO_FLUSH_NOOP
    }

    [CCode (cname = "int", cprefix = "FF_CMP_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFCmp
    {
        SAD,
        SSE,
        SATD,
        DCT,
        PSNR,
        BIT,
        RD,
        ZERO,
        VSAD,
        VSSE,
        NSSE,
        W53,
        W97,
        DCTMAX,
        DCT264,
        CHROMA
    }

    [Flags, CCode (cname = "int", cprefix = "SLICE_FLAG_", cheader_filename = "libavcodec/avcodec.h")]
    public enum SliceFlag
    {
        CODED_ORDER,
        ALLOW_FIELD,
        ALLOW_PLANE
    }

    [Flags, CCode (cname = "int", cprefix = "FF_MB_DECISION_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFMbDecision
    {
        SIMPLE,
        BITS,
        RD
    }

    [CCode (cname = "enum AVAudioServiceType", cprefix = "AV_AUDIO_SERVICE_TYPE_", cheader_filename = "libavcodec/avcodec.h")]
    public enum AudioServiceType
    {
        MAIN,
        EFFECTS,
        VISUALLY_IMPAIRED,
        HEARING_IMPAIRED,
        DIALOGUE,
        COMMENTARY,
        EMERGENCY,
        VOICE_OVER,
        KARAOKE
    }

    [SimpleType, CCode (cname = "RcOverride", cheader_filename = "libavcodec/avcodec.h")]
    public struct RcOverride
    {
        public int start_frame;
        public int end_frame;
        public int qscale;
        public float quality_factor;
    }

    [Flags, CCode (cname = "int", cprefix = "FF_BUG_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFBug
    {
        AUTODETECT,
        OLD_MSMPEG4,
        XVID_ILACE,
        UMP4,
        NO_PADDING,
        AMV,
        AC_VLC,
        QPEL_CHROMA,
        STD_QPEL,
        QPEL_CHROMA2,
        DIRECT_BLOCKSIZE,
        EDGE,
        HPEL_CHROMA,
        DC_CLIP,
        MS,
        TRUNCATED
    }

    [CCode (cname = "int", cprefix = "FF_COMPLIANCE_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFCompliance
    {
        VERY_STRICT,
        STRICT,
        NORMAL,
        UNOFFICIAL,
        EXPERIMENTAL
    }

    [Flags, CCode (cname = "int", cprefix = "FF_EC_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFEc
    {
        GUESS_MVS,
        DEBLOCK,
        FAVOR_INTER
    }

    [Flags, CCode (cname = "int", cprefix = "FF_DEBUG_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFDebug
    {
        PICT_INFO,
        RC,
        BITSTREAM,
        MB_TYPE,
        MV,
        DCT_COEFF,
        SKIP,
        STARTCODE,
        PTS,
        ER,
        MMCO,
        BUGS,
        VIS_QP,
        VIS_MB_TYPE,
        BUFFERS,
        THREADS,
        GREEN_MD,
        NOMC
    }

    [Flags, CCode (cname = "int", cprefix = "AV_EF_", cheader_filename = "libavcodec/avcodec.h")]
    public enum EF
    {
        CRCCHECK,
        BITSTREAM,
        BUFFER,
        EXPLODE,
        IGNORE_ERR,
        CAREFUL,
        COMPLIANT,
        AGGRESSIVE
    }

    [CCode (cname = "int", cprefix = "FF_DCT_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFDct
    {
        AUTO,
        FASTINT,
        INT,
        MMX,
        ALTIVEC,
        FAAN
    }

    [CCode (cname = "int", cprefix = "FF_IDCT_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFIdct
    {
        AUTO,
        INT,
        SIMPLE,
        SIMPLEMMX,
        ARM,
        ALTIVEC,
        SH4,
        SIMPLEARM,
        IPP,
        XVID,
        XVIDMMX,
        SIMPLEARMV5TE,
        SIMPLEARMV6,
        SIMPLEVIS,
        FAAN,
        ALPHA,
        SIMPLEALPHA,
        SIMPLEAUTO
    }

    [CCode (cname = "int", cprefix = "FF_THREAD_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFThread
    {
        FRAME,
        SLICE
    }

    [Flags, CCode (cname = "int", cprefix = "AV_CODEC_PROP_", cheader_filename = "libavcodec/avcodec.h")]
    public enum Prop
    {
        INTRA_ONLY,
        LOSSY,
        LOSSLESS,
        REORDER,
        BITMAP_SUB,
        TEXT_SUB
    }

    [SimpleType, CCode (cname = "AVCodecDescriptor", cheader_filename = "libavcodec/avcodec.h")]
    public struct Descriptor
    {
        public ID             id;
        public Util.MediaType type;
        public string         name;
        public string         long_name;
        public Prop           props;
        [CCode (array_null_terminated = true)]
        public string[]       mime_types;
        [CCode (array_length = false)]
        public Profile[]      profiles;
    }

    [CCode (cname = "int", cprefix = "FF_SUB_CHARENC_MODE_", cheader_filename = "libavcodec/avcodec.h")]
    public enum FFSubCharencMode
    {
        DO_NOTHING,
        AUTOMATIC,
        PRE_DECODER
    }

    [Compact, CCode (cname = "AVCodecContext", free_function = "avcodec_free_context", free_function_address_of = true, cheader_filename = "libavcodec/avcodec.h")]
    public class Context
    {
        public int                  log_level_offset;
        public Util.MediaType       codec_type;
        public Codec                codec;
        public ID                   codec_id;
        public uint                 codec_tag;
        public Format.Internal      @internal;
        public int64                bit_rate;
        public int                  bit_rate_tolerance;
        public int                  global_quality;
        public int                  compression_level;
        public Flag                 flags;
        public Flag2                flags2;
        [CCode (array_length_cname = "extradata_size")]
        public uint8[]              extradata;
        public Util.Rational        time_base;
        public int                  ticks_per_frame;
        public int                  delay;
        public int                  width;
        public int                  height;
        public int                  coded_width;
        public int                  coded_height;
        public int                  gop_size;
        public Util.PixelFormat     pix_fmt;
        public int                  max_b_frames;
        public float                b_quant_factor;
        public float                b_quant_offset;
        public int                  has_b_frames;
        public float                i_quant_factor;
        public float                i_quant_offset;
        public float                lumi_masking;
        public float                temporal_cplx_masking;
        public float                spatial_cplx_masking;
        public float                p_masking;
        public float                dark_masking;
        public int                  slice_count;
        public int*                 slice_offset;
        public Util.Rational        sample_aspect_ratio;
        public int                  me_cmp;
        public int                  me_sub_cmp;
        public int                  mb_cmp;
        public int                  ildct_cmp;
        public int                  dia_size;
        public int                  last_predictor_count;
        public int                  me_pre_cmp;
        public int                  pre_dia_size;
        public int                  me_subpel_quality;
        public int                  me_range;
        public SliceFlag            slice_flags;
        public FFMbDecision         mb_decision;
        [CCode (array_length = false)]
        public uint16[]             intra_matrix;
        [CCode (array_length = false)]
        public uint16[]             inter_matrix;
        public int                  intra_dc_precision;
        public int                  skip_top;
        public int                  skip_bottom;
        public int                  mb_lmin;
        public int                  mb_lmax;
        public int                  bidir_refine;
        public int                  keyint_min;
        public int                  refs;
        public int                  mv0_threshold;
        public Util.ColorPrimaries  color_primaries;
        public Util.ColorTransferCharacteristic color_trc;
        public Util.ColorSpace      colorspace;
        public Util.ColorRange      color_range;
        public Util.ChromaLocation  chroma_sample_location;
        public int                  slices;
        public FieldOrder           field_order;
        public int                  sample_rate;
        public int                  channels;
        public Util.Sample.Format   sample_fmt;
        public int                  frame_size;
        public int                  frame_number;
        public int                  block_align;
        public int                  cutoff;
        public uint64               channel_layout;
        public uint64               request_channel_layout;
        public AudioServiceType     audio_service_type;
        public Util.Sample.Format   request_sample_fmt;
        public int                  refcounted_frames;
        public float                qcompress;
        public float                qblur;
        public int                  qmin;
        public int                  qmax;
        public int                  max_qdiff;
        public int                  rc_buffer_size;
        [CCode (array_length_cname = "rc_override_count")]
        public RcOverride[]         rc_override;
        public int64                rc_max_rate;
        public int64                rc_min_rate;
        public float                rc_max_available_vbv_use;
        public float                rc_min_vbv_overflow_use;
        public int                  rc_initial_buffer_occupancy;
        public int                  trellis;
        public string               stats_out;
        public string               stats_in;
        public FFBug                workaround_bugs;
        public FFCompliance         strict_std_compliance;
        public FFEc                 error_concealment;
        public FFDebug              debug;
        public int                  debug_mv;
        public EF                   err_recognition;
        public int64                reordered_opaque;
        //public HWAccel              hwaccel;
        //public void*                hwaccel_context;
        //public uint64[]             error;
        public FFDct                dct_algo;
        public FFIdct               idct_algo;
        public int                  bits_per_coded_sample;
        public int                  bits_per_raw_sample;
        public int                  lowres;
        public int                  thread_count;
        public FFThread             thread_type;
        public int                  active_thread_type;
        public int                  thread_safe_callbacks;
        public int                  nsse_weight;
        public FFProfile            profile;
        public int                  level;
        public Discard              skip_loop_filter;
        public Discard              skip_idct;
        public Discard              skip_frame;
        [CCode (array_length_cname = "subtitle_header_size")]
        public uint8[]              subtitle_header;
        public int                  initial_padding;
        public Util.Rational        framerate;
        public Util.PixelFormat     sw_pix_fmt;
        public Util.Rational        pkt_timebase;
        public Descriptor           codec_descriptor;
        public int64                pts_correction_num_faulty_pts;
        public int64                pts_correction_num_faulty_dts;
        public int64                pts_correction_last_pts;
        public int64                pts_correction_last_dts;
        public string               sub_charenc;
        public FFSubCharencMode     sub_charenc_mode;
        public int                  skip_alpha;
        public int                  seek_preroll;
        [CCode (array_length = false)]
        public uint16[]             chroma_intra_matrix;
        [CCode (array_length = false)]
        public uint8[]              dump_separator;
        public string               codec_whitelist;
        [CCode (array_length_cname = "nb_coded_side_data")]
        public PacketSideData[]     coded_side_data;

        [CCode (cname = "avcodec_alloc_context3")]
        public Context (Codec codec);

        [CCode (cname = "avcodec_parameters_to_context")]
        public int set_parameters (Parameters param);

        [CCode (cname = "avcodec_open2")]
        public int open (Codec? codec, out Util.Dictionary? dict);

        [CCode (cname = "avcodec_send_packet")]
        public int send_packet (Packet packet);

        [CCode (cname = "avcodec_receive_frame")]
        public int receive_frame (Util.Frame frame);

        [CCode (cname = "avcodec_close")]
        public int close ();
    }
}
