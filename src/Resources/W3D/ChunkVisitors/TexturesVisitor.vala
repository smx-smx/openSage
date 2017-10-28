using OpenSage.Support;
using Vapi.W3D.Chunk;
using Gee;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class TexturesVisitor : ChunkVisitor {

		public ArrayList<TextureVisitor?> textures = new ArrayList<TextureVisitor?>();

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
					TextureVisitor texture = new TextureVisitor(cursor);
					textures.add(texture);
					return texture.run();
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}