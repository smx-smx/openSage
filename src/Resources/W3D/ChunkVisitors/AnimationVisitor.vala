using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class AnimationVisitor : ChunkVisitor {
//		public unowned CGlm.Vector3[] channels;

		public AnimationVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.ANIMATION_HEADER:
				case ChunkType.ANIMATION_CHANNEL:
				case ChunkType.BIT_CHANNEL:
					return true;
				default:
					return false;
			}
		}

		public VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.ANIMATION_HEADER:
					stdout.printf("[ANIMATION] => Header\n");
					return VisitorResult.OK;
				case ChunkType.ANIMATION_CHANNEL:
					stdout.printf("[ANIMATION] => Channel\n");
					return VisitorResult.OK;
				case ChunkType.BIT_CHANNEL:
					stdout.printf("[ANIMATION] => Bit Channel\n");
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}
