namespace Posix {
	public enum BufferMode {
		[CCode(cname = "_IONBF")]
		Unbuffered
	}
	public int setvbuf (Posix.FILE stream, string? buffer, int mode, size_t size);
	
	public void* calloc(size_t num, size_t size);
}