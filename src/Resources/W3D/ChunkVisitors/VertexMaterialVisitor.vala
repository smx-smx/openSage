using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class VertexMaterialVisitor : ChunkVisitor {

		public MaterialInfo *material_info;
		public unowned string args0;
		public unowned string args1;

		public VertexMaterialVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.VERTEX_MATERIAL_NAME:
				case ChunkType.VERTEX_MATERIAL_INFO:
				case ChunkType.VERTEX_MAPPER_ARGS0:
				case ChunkType.VERTEX_MAPPER_ARGS1:
					return true;
				default:
					return false;
			}
		}

		public VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.VERTEX_MATERIAL_NAME:
					stdout.printf("[VERTEXMATERIAL] => Material Name\n");
					return VisitorResult.OK;
				case ChunkType.VERTEX_MATERIAL_INFO:
					stdout.printf("[VERTEXMATERIAL] => Material Info\n");
					material_info = (MaterialInfo *)(cursor.ptr);				
					cursor.skip((long)sizeof(MaterialInfo));
					return VisitorResult.OK;
				case ChunkType.VERTEX_MAPPER_ARGS0:
					stdout.printf("[VERTEXMATERIAL] => Mapper Args0\n");
					args0 = (string)(cursor.ptr);
					cursor.skip(args0.length + 1);
					return VisitorResult.OK;
				case ChunkType.VERTEX_MAPPER_ARGS1:
					stdout.printf("[VERTEXMATERIAL] => Mapper Args1\n");
					args1 = (string)(cursor.ptr);
					cursor.skip(args1.length + 1);
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}