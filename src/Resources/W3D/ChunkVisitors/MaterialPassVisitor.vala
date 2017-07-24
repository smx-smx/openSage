using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class MaterialPassVisitor : ChunkVisitor {

		public TextureStageVisitor texture_stage;

		public MaterialPassVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.VERTEX_MATERIAL_IDS:
				case ChunkType.SHADER_IDS:
				case ChunkType.TEXTURE_STAGE:
					return true;
				default:
					return false;
			}
		}

		public VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.VERTEX_MATERIAL_IDS:
					stdout.printf("[MATERIALPASS] => Vertex Material IDs\n");
					return VisitorResult.OK;
				case ChunkType.SHADER_IDS:
					stdout.printf("[MATERIALPASS] => Shader IDs\n");
					return VisitorResult.OK;
				case ChunkType.TEXTURE_STAGE:
					stdout.printf("[MATERIALPASS] => Texture Stage\n");
					texture_stage = new TextureStageVisitor(cursor);
					return texture_stage.run();
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}