namespace OpenSage.Support {
	public class StreamCursor {
		private unowned uint8[] buffer;
		private uint8 *cursor;
		private uint8 *start;
		private uint8 *end;

		public uint8 *ptr {
			get {
				return cursor;
			}
		}

		public unowned uint8[] data {
			get {
				return buffer;
			}
		}

		public ulong position {
			get {
				return (cursor - start);
			}
		}

		public StreamCursor(uint8[] data){
			buffer = data;
			cursor = buffer;
			start = cursor;
			end = cursor + buffer.length;
		}

		public void seek(long offset, SeekType whence){
			switch(whence){
				case SeekType.SET:
					cursor = start + offset;
					break;
				case SeekType.CUR:
					cursor += offset;
					break;
				case SeekType.END:
					cursor = end + offset;
					break;
			}
		}

		public void skip(long offset){
			seek(offset, SeekType.CUR);
		}

		public void rewind(){
			seek(0, SeekType.SET);
		}

		public void skip_all(){
			seek(0, SeekType.END);
		}

		public ulong tell(){
			return (ulong)(cursor - start);
		}
	}
}
