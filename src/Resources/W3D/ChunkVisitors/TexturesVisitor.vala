using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class TexturesVisitor : ChunkVisitor {

		public TextureVisitor texture;

		public TexturesVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.TEXTURE:
					return true;
				default:
					return false;
			}
		}

		public VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.TEXTURE:
					stdout.printf("[TEXTURES] => Texture\n");
					texture = new TextureVisitor(cursor);
					return texture.run();
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}