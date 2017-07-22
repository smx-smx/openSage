using Posix;
namespace OpenSage {

public class Utils {
	public static void hexdump(uint8 *data, size_t size) {
        var builder = new StringBuilder.sized (16);
        var i = 0;

		for(var b=0; b<size; b++){
			var c = data[b];
            if (i % 16 == 0) {
                print ("%08x | ", i);
            }
            i++;
            print ("%02x ", c);
            if (((char) c).isprint ()) {
                builder.append_c ((char) c);
            } else {
                builder.append (".");
            }
            if (i % 16 == 0) {
                print ("| %s\n", builder.str);
                builder.erase ();
            }
        }

        if (i % 16 != 0) {
            print ("%s| %s\n", string.nfill ((16 - (i % 16)) * 3, ' '), builder.str);
        }

    }
    
    public static uint8[] null_terminate(owned uint8[] buf){
        buf.resize(buf.length + 1);
        buf[buf.length - 2] = 0x00;
        return buf;
    }

    public static uint8[]? file_get_contents(string path){
        var file = File.new_for_path(path);
        if(!file.query_exists())
            return null;
        
        var file_info = file.query_info ("*", FileQueryInfoFlags.NONE);
        var file_size = file_info.get_size();

        var file_stream = file.read ();
        var data_stream = new DataInputStream (file_stream);
        uint8[] buffer = new uint8[file_size];
        data_stream.read (buffer);

        return buffer;
    }
}

}