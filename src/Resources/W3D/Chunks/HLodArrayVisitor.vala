using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.Chunks {
	public class HLodArrayVisitor : ChunkVisitor {
		public HLodArrayVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.HLOD_SUB_OBJECT_ARRAY_HEADER:
				case ChunkType.HLOD_SUB_OBJECT:
					return true;
				default:
					return false;
			}
		}

		public VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.HLOD_SUB_OBJECT_ARRAY_HEADER:
					stdout.printf("[HLOD_ARRAY] => Header\n");
					return VisitorResult.OK;
				case ChunkType.HLOD_SUB_OBJECT:				
					stdout.printf("[HLOD_ARRAY] => Sub Object\n");
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}