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
}