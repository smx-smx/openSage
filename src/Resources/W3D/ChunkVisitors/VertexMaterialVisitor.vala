using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class VertexMaterialVisitor : ChunkVisitor {

		public VertexMaterialVisitor vertex_material;

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
					return VisitorResult.OK;
				case ChunkType.VERTEX_MAPPER_ARGS0:
					stdout.printf("[VERTEXMATERIAL] => Mapper Args0\n");
					return VisitorResult.OK;
				case ChunkType.VERTEX_MAPPER_ARGS1:
					stdout.printf("[VERTEXMATERIAL] => Mapper Args1\n");
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}