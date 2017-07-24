namespace OpenSage.Resources.W3D {
	public class Utils {
		public static unowned uint8[] chunk_to_buffer(Vapi.W3D.Chunk.ChunkHeader *hdr){
			unowned uint8[] buf = (uint8 [])hdr;
			buf.length = (int)hdr.ChunkSize;
			
			return buf;
		}
	}
}