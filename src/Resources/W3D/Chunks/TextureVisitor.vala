using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.Chunks {
	public class TextureVisitor : ChunkVisitor {

		public TextureVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.TEXTURE_NAME:
					return true;
				default:
					return false;
			}
		}

		public VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.TEXTURE_NAME:
					stdout.printf("[TEXTURE] => Texture Name\n");
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}