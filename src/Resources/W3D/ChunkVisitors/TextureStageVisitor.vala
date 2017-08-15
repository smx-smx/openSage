using OpenSage.Support;
using Vapi.W3D.Chunk;

using CGlm;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class TextureStageVisitor : ChunkVisitor {
		public unowned TextureCoordinates[] texcoords;

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
					texcoords = (TextureCoordinates[])(cursor.ptr);
					texcoords.length = (int)(hdr.ChunkSize / sizeof(TextureCoordinates));
					cursor.skip(texcoords.length * (long)sizeof(TextureCoordinates));
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}