using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D {
	public struct ChunkHeader {
		private uint32 chunkSize;

		public ChunkType ChunkType;
		public uint32 ChunkSize {
			get {
				return chunkSize & 0x7FFFFFFF;
			}	
		}

		/**
		 * The MSB in size indicates if this Chunk has other subchunks
		 */
		public bool HasSubChunks {
			get {
				return (bool)((chunkSize >> 27) & 1);
			}
		}

		public static ChunkHeader import(Vapi.W3D.Chunk.ChunkHeader *data){
			ChunkHeader hdr = ChunkHeader();
			hdr.ChunkType = data.ChunkType;
			hdr.chunkSize = data.ChunkSize;
			return hdr;
		}
	}
}	