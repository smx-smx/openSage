using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class TextureStageVisitor : ChunkVisitor {

		public TextureStageVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.TEXTURE_IDS:
				case ChunkType.STAGE_TEXCOORDS:
					return true;
				default:
					return false;
			}
		}

		public VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.TEXTURE_IDS:
					stdout.printf("[TEXTURE_STAGE] => Texture IDs\n");
					return VisitorResult.OK;
				case ChunkType.STAGE_TEXCOORDS:
					stdout.printf("[TEXTURE_STAGE] => Stage TexCoords\n");
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}