using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.Chunks {
	public class VertexMaterialsVisitor : ChunkVisitor {

		public VertexMaterialVisitor vertex_material;

		public VertexMaterialsVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.VERTEX_MATERIAL:
					return true;
				default:
					return false;
			}
		}

		public VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.VERTEX_MATERIAL:
					stdout.printf("[VERTEXMATERIALS] => Vertex Material\n");
					vertex_material = new VertexMaterialVisitor(cursor);
					return vertex_material.run();
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}