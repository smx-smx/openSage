using Posix;

[CCode(cprefix = "", lower_case_cprefix = "", cheader_filename = "mfile.h")]
namespace MFile {
	[Compact, CCode(cname = "cursor_t")]
	public struct Cursor {
		public uint8* ptr;
		public off_t offset;
		public size_t size;
		//TODO
	}


	/*
	 * Represents a memory-mapped file
	 */
	[Compact, CCode(free_function = "mclose")]
	public class MFILE {
		[CCode(cname = "mfile_new")]
		public MFILE();

		[CCode(cname = "mopen")]
		public static MFILE open(string path, int open_flags);
		[CCode(cname = "mopen_private")]
		public static MFILE open_private(string path, int oflags);
		[CCode(cname = "mfopen")]
		public static MFILE fopen(string path, string mode);
		[CCode(cname = "mfopen_private")]
		public static MFILE fopen_private(string path, string mode);

		[CCode(cname = "mwrite", instance_pos = -1)]
		public void write(void* ptr, size_t size, uint nmemb);

		[CCode(cname = "mwriteat")]
		public void write_at(off_t off, void* ptr, size_t size);

		[CCode(cname = "msize")]
		public size_t size();

		[CCode(cname = "mfh")]
		public FILE handle;

		[CCode(cname = "mbytes", array_length = false)]
		public unowned uint8* data();

		[CCode(cname = "moff")]
		public off_t offset_of(void* ptr);

		[CCode(cname = "mrewind")]
		public void rewind();

		[CCode(cname = "mfile_map")]
		public unowned uint8* map(size_t size);

		[CCode(cname = "mfile_map_private")]
		public unowned uint8* map_private(size_t size);

		[CCode(cname = "mgetc")]
		int getc();
		
		[CCode(cname = "mputc", instance_pos = -1)]
		int putc(int c);
	}
}