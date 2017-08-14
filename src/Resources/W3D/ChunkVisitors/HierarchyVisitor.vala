using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class HierarchyVisitor : ChunkVisitor {
		public Vapi.W3D.HTree.Hierarchy *header;

		/*
		 * Pivots are used to connect the different shapes
		 * that make up a model
		 * They contain translations needed by each shape and other infos
		 */
		public unowned Vapi.W3D.HTree.Pivot[] pivots;

		// only needed by the exporter
		public unowned Vapi.W3D.HTree.PivotFixup[] pivotsFixups;

		public HierarchyVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.HIERARCHY_HEADER:
				case ChunkType.PIVOTS:
				case ChunkType.PIVOT_FIXUPS:
					return true;
				default:
					return false;
			}
		}

		private VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.HIERARCHY_HEADER:
					stdout.printf("[HTREE] => Header\n");
					header = (Vapi.W3D.HTree.Hierarchy *)(cursor.ptr);
					cursor.skip((long)sizeof(Vapi.W3D.HTree.Hierarchy));
					return VisitorResult.OK;
				case ChunkType.PIVOTS:
					stdout.printf("[HTREE] => Pivots\n");
					pivots = (Vapi.W3D.HTree.Pivot[])(cursor.ptr);
					pivots.length = (int)header.NumPivots;
					cursor.skip((long)sizeof(Vapi.W3D.HTree.Pivot) * header.NumPivots);
					return VisitorResult.OK;
				case ChunkType.PIVOT_FIXUPS: //only needed by the exporter ??
					stdout.printf("[HTREE] => Pivot Fixups\n");
					pivotsFixups = (Vapi.W3D.HTree.PivotFixup[])(cursor.ptr);
					pivotsFixups.length = (int)header.NumPivots;
					cursor.skip((long)sizeof(Vapi.W3D.HTree.PivotFixup) * header.NumPivots);
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}
