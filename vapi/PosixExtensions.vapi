namespace Posix {
	public enum BufferMode {
		[CCode(cname = "_IONBF")]
		Unbuffered
	}
	public static int setvbuf ( Posix.FILE  stream, string buffer, int mode, size_t size );
}