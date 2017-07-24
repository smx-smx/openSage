using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class HierarchyVisitor : ChunkVisitor {
		public Vapi.W3D.HTree.Hierarchy *hierarchy;
		public unowned Vapi.W3D.HTree.Pivot[] pivots;
		public unowned Vapi.W3D.HTree.PivotFixup[] pivotsFixups;

		public HierarchyVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
			//visitor = new ChunkVisitor(ptr, isKnown, visit);
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
					hierarchy = (Vapi.W3D.HTree.Hierarchy *)(cursor.ptr);
					cursor.skip((long)sizeof(Vapi.W3D.HTree.Hierarchy));
					return VisitorResult.OK;
				case ChunkType.PIVOTS:
					stdout.printf("[HTREE] => Pivots\n");
					pivots = (Vapi.W3D.HTree.Pivot[])(cursor.ptr);
					pivots.length = (int)hierarchy.NumPivots;
					cursor.skip((long)sizeof(Vapi.W3D.HTree.Pivot) * hierarchy.NumPivots);
					return VisitorResult.OK;
				case ChunkType.PIVOT_FIXUPS: //only needed by the exporter ??
					stdout.printf("[HTREE] => Pivot Fixups\n");
					pivotsFixups = (Vapi.W3D.HTree.PivotFixup[])(cursor.ptr);
					pivotsFixups.length = (int)hierarchy.NumPivots;
					cursor.skip((long)sizeof(Vapi.W3D.HTree.PivotFixup) * hierarchy.NumPivots);
					return VisitorResult.OK;
			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}
