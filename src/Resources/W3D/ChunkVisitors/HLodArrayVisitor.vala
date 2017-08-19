using OpenSage.Support;
using Vapi.W3D.Chunk;
using Vapi.W3D.HLod;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class HLodArrayVisitor : ChunkVisitor {
		public HLodArrayHeader *header;
		public HLodSubObject*[] objects;

		private int last_obj_idx = 0;
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
					header = (HLodArrayHeader *)(cursor.ptr);
					cursor.skip((long)sizeof(HLodArrayHeader));

					objects = new HLodSubObject*[header.ModelCount];
					return VisitorResult.OK;
				case ChunkType.HLOD_SUB_OBJECT:				
					stdout.printf("[HLOD_ARRAY] => Sub Object\n");
					HLodSubObject *sobj = (HLodSubObject *)(cursor.ptr);
					objects[last_obj_idx++] = sobj;

					cursor.skip((long)sizeof(HLodSubObject));
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}