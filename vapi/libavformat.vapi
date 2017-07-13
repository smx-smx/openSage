namespace Av.Format
{
    [CCode (cname = "av_register_all", cheader_filename = "libavformat/avformat.h")]
    public void register_all ();

    [CCode (cheader_filename = "avio.h")]
    namespace IO
    {
        public delegate int InterruptCallback ();

        [CCode (cname = "AVIOInterruptCB", has_destroy_function = false, has_copy_function = false)]
        public struct InterruptCB
        {
            [CCode (delegate_target_cname = "opaque")]
            public unowned InterruptCallback @callback;
        }
    }

    [Flags, CCode (cname = "int", cprefix = "AVFMT_", cheader_filename = "libavformat/avformat.h")]
    public enum Flag
    {
        NOFILE,
        NEEDNUMBER,
        SHOW_IDS,
        GLOBALHEADER,
        NOTIMESTAMPS,
        GENERIC_INDEX,
        TS_DISCONT,
        VARIABLE_FPS,
        NODIMENSIONS,
        NOSTREAMS,
        NOBINSEARCH,
        NOGENSEARCH,
        NO_BYTE_SEEK,
        ALLOW_FLUSH,
        TS_NONSTRICT,
        TS_NEGATIVE,
        SEEK_TO_PTS
    }

    [Compact, CCode (cname = "AVInputFormat", cheader_filename = "libavformat/avformat.h")]
    public class InputFormat
    {
        public string name;
        public string long_name;
        public Flag   flags;
        public string extensions;
        public string mime_type;
    }

    [Compact, CCode (cname = "AVOutputFormat", cheader_filename = "libavformat/avformat.h")]
    public class OutputFormat
    {
        public string   name;
        public string   long_name;
        public string   mime_type;
        public string   extensions;
        public Codec.ID audio_codec;
        public Codec.ID video_codec;
        public Codec.ID subtitle_codec;
        public Flag     flags;
    }

    [CCode (cname = "int", cprefix = "AV_DISPOSITION_", cheader_filename = "libavformat/avformat.h")]
    public enum Disposition
    {
        DEFAULT,
        DUB,
        ORIGINAL,
        COMMENT,
        LYRICS,
        KARAOKE,
        FORCED,
        HEARING_IMPAIRED,
        VISUAL_IMPAIRED,
        CLEAN_EFFECTS,
        ATTACHED_PIC,
        CAPTIONS,
        DESCRIPTIONS,
        METADATA
    }

    [Compact, CCode (cname = "AVStream", cheader_filename = "libavformat/avformat.h")]
    public class Stream
    {
        [Flags, CCode (cname = "int", cprefix = "AVSTREAM_EVENT_FLAG_")]
        public enum EventFlag
        {
            METADATA_UPDATED
        }

        public int                      index;
        public int                      id;
        public Util.Rational            time_base;
        public int64                    start_time;
        public int64                    duration;
        public int64                    nb_frames;
        public Disposition              disposition;
        public Codec.Discard            discard;
        public Util.Rational            sample_aspect_ratio;
        public Util.Dictionary          metadata;
        public Util.Rational            avg_frame_rate;
        public Codec.Packet             attached_pic;
        [CCode (array_length_cname = "nb_side_data")]
        public Codec.PacketSideData[]   side_data;
        public EventFlag                event_flags;
        public Codec.Parameters         codecpar;
    }

    [Compact, CCode (cname = "AVProgram", cheader_filename = "libavformat/avformat.h")]
    public class Program
    {
        public int              id;
        public int             flags;
        public Codec.Discard   discard;
        [CCode (array_length_cname = "nb_stream_indexes")]
        public uint[]          stream_index;
        public Util.Dictionary metadata;
        public int             program_num;
        public int             pmt_pid;
        public int             pcr_pid;
    }

    [Compact, CCode (cname = "AVChapter", cheader_filename = "libavformat/avformat.h")]
    public class Chapter
    {
        public int             id;
        public Util.Rational   time_base;
        public int64           start;
        public int64           end;
        public Util.Dictionary metadata;
    }

    [CCode (cname = "enum AVDurationEstimationMethod", cprefix = "AVFMT_DURATION_FROM_", cheader_filename = "libavformat/avformat.h")]
    public enum DurationEstimationMethod
    {
        PTS,
        STREAM,
        BITRATE
    }

    [Compact, CCode (cname = "AVFormatInternal", cheader_filename = "libavformat/avformat.h")]
    public class Internal
    {
    }

    [Flags, CCode (cname = "int", cprefix = "AVSEEK_FLAG_", cheader_filename = "libavformat/avformat.h")]
    public enum SeekFlag
    {
        BACKWARD,
        BYTE,
        ANY,
        FRAME
    }

    [Compact, CCode (cname = "AVFormatContext", free_function = "avformat_free_context", cheader_filename = "libavformat/avformat.h")]
    public class Context
    {
        [Flags, CCode (cname = "int", cprefix = "AVFMT_FLAG_")]
        public enum Flag
        {
            GENPTS,
            IGNIDX,
            NONBLOCK,
            IGNDTS,
            NOFILLIN,
            NOPARSE,
            NOBUFFER,
            CUSTOM_IO,
            DISCARD_CORRUPT,
            FLUSH_PACKETS,
            BITEXACT,
            MP4A_LATM,
            SORT_DTS,
            PRIV_OPT,
            KEEP_SIDE_DATA,
            FAST_SEEK
        }

        [Flags, CCode (cname = "int", cprefix = "AVFMT_EVENT_FLAG_")]
        public enum EventFlag
        {
            METADATA_UPDATED
        }

        [Flags, CCode (cname = "int", cprefix = "AVFMT_AVOID_NEG_TS_")]
        public enum AvoidNegTs
        {
            AUTO,
            MAKE_NON_NEGATIVE,
            MAKE_ZERO
        }

        public InputFormat              iformat;
        public OutputFormat             oformat;
        public int                      ctx_flags;
        [CCode (array_length_cname = "nb_streams")]
        public Stream[]                 streams;
        public string                   filename;
        public int64                    start_time;
        public int64                    duration;
        public int64                    bit_rate;
        public uint                     packet_size;
        public int                      max_delay;
        public Flag                     flags;
        public int64                    probesize;
        public int64                    max_analyze_duration;
        [CCode (array_length_cname = "keylen")]
        public uint8[]                  key;
        [CCode (array_length_cname = "nb_programs")]
        public Program[]                programs;
        public Codec.ID                 video_codec_id;
        public Codec.ID                 audio_codec_id;
        public Codec.ID                 subtitle_codec_id;
        public uint                     max_index_size;
        public uint                     max_picture_buffer;
        [CCode (array_length_cname = "nb_chapters")]
        public Chapter[]                chapters;
        public Util.Dictionary          metadata;
        public int64                    start_time_realtime;
        public int                      fps_probe_size;
        public int                      error_recognition;
        public IO.InterruptCB           interrupt_callback;
        public int64                    max_interleave_delta;
        public int                      strict_std_compliance;
        public EventFlag                event_flags;
        public int                      max_ts_probe;
        public AvoidNegTs               avoid_negative_ts;
        public int                      ts_id;
        public int                      audio_preload;
        public int                      max_chunk_duration;
        public int                      max_chunk_size;
        public int                      use_wallclock_as_timestamps;
        public int                      avio_flags;
        public DurationEstimationMethod duration_estimation_method;
        public int64                    skip_initial_bytes;
        public uint                     correct_ts_overflow;
        public int                      seek2any;
        public int                      flush_packets;
        public int                      probe_score;
        public int                      format_probesize;
        public string                   codec_whitelist;
        public string                   format_whitelist;
        public Internal                 @internal;
        public int                      io_repositioned;
        public Codec.Codec              video_codec;
        public Codec.Codec              audio_codec;
        public Codec.Codec              subtitle_codec;
        public Codec.Codec              data_codec;
        public int                      metadata_header_padding;
        public int64                    output_ts_offset;
        public Codec.ID                 data_codec_id;
        public string                   protocol_whitelist;

        [CCode (cname = "avformat_alloc_context")]
        public Context ();
        [CCode (cname = "avformat_alloc_output_context2")]
        public static int alloc_output_context2 (out Context context, OutputFormat? oformat, string? format_name, string? filename);
        [CCode (cname = "avformat_open_input")]
        public static int open_input(out unowned Context? context, string url, InputFormat? fmt, out Util.Dictionary? options);
        [CCode (cname = "avformat_find_stream_info")]
        public int find_stream_info(out Util.Dictionary? options);
        [CCode (cname = "av_find_best_stream")]
        public int find_best_stream(Util.MediaType type, int wanted_stream_nb, int related_stream, out unowned Codec.Codec? decoder_ret, int flags);
        [CCode (cname = "avformat_close_input")]
        public static void close_input (ref unowned Context ctx);
        [CCode (cname = "av_dump_format")]
        public void dump_format (int index, string url, bool is_input);
        [CCode (cname = "av_read_frame")]
        public int read_frame (Codec.Packet packet);
        [CCode (cname = "av_seek_frame")]
        public int seek_frame(int stream_index, int64 timestamp, SeekFlag flags);
    }
}
