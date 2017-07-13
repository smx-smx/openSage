[CCode (cheader_filename = "libavresample/avresample.h")]
namespace Av.Resample
{
    [CCode (cname = "enum AVMixCoeffType", cprefix = "AV_MIX_COEFF_TYPE_")]
    public enum MixCoeffType
    {
        Q8,
        Q15,
        FLT
    }

    [CCode (cname = "enum AVResampleFilterType", cprefix = "AV_RESAMPLE_FILTER_TYPE_")]
    public enum AVResampleFilterType
    {
        CUBIC,
        BLACKMAN_NUTTALL,
        KAISER
    }

    [CCode (cname = "enum AVResampleDitherMethod", cprefix = "AV_RESAMPLE_DITHER_")]
    public enum AVResampleDitherMethod
    {
        NONE,
        RECTANGULAR,
        TRIANGULAR,
        TRIANGULAR_HP,
        NS
    }

    [Compact, CCode (cname = "AVAudioResampleContext", free_function = "avresample_free", free_function_address_of = true)]
    public class Context
    {
        public bool is_open {
            [CCode (cname = "avresample_is_open")]
            get;
        }

        public int delay {
            [CCode (cname = "avresample_get_delay")]
            get;
        }

        public int available {
            [CCode (cname = "avresample_available")]
            get;
        }

        [CCode (cname = "avresample_alloc_context")]
        public Context ();

        [CCode (cname = "avresample_open")]
        public int open ();

        [CCode (cname = "avresample_close")]
        public void close ();

        [CCode (cname = "avresample_build_matrix")]
        public static int build_matrix(uint64 in_layout, uint64 out_layout, double center_mix_level, double surround_mix_level, double lfe_mix_level, int normalize, [CCode (array_length = false)]double[] matrix, int stride, Av.Util.ChannelLayout.MatrixEncoding matrix_encoding);

        [CCode (cname = "avresample_get_matrix")]
        public int get_matrix([CCode (array_length = false)]double[] matrix, int stride);

        [CCode (cname = "avresample_set_matrix")]
        public int set_matrix([CCode (array_length = false)]double[] matrix, int stride);

        [CCode (cname = "avresample_set_channel_mapping")]
        public int set_channel_mapping([CCode (array_length = false)]int[] channel_map);

        [CCode (cname = "avresample_set_compensation")]
        public int set_compensation(int sample_delta, int compensation_distance);

        [CCode (cname = "avresample_get_out_samples")]
        public int get_out_samples(int in_nb_samples);

        [CCode (cname = "avresample_convert")]
        public int convert([CCode (array_length_pos = 2.1)]uint8[] output, int out_plane_size, [CCode (array_length_pos = 2.4)]uint8[] input, int in_plane_size);

        [CCode (cname = "avresample_read")]
        public int read([CCode (array_length = false)]uint8[] output, int nb_samples);

        [CCode (cname = "avresample_convert_frame")]
        public int convert_frame(Av.Util.Frame output, Av.Util.Frame input);

        [CCode (cname = "avresample_config")]
        public int config(Av.Util.Frame output, Av.Util.Frame input);
    }
}
