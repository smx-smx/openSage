using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class TextureVisitor : ChunkVisitor {
		public unowned string texture_name;

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
					texture_name = (string)(cursor.ptr);
					cursor.skip(texture_name.length + 1);
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}