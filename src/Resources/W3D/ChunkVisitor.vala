using OpenSage;
using OpenSage.Support;

using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.Chunks {
	
	public enum VisitorResult {
		UNKNOWN_DATA = -3,
		UNHANDLED_CHUNK = -2,
		UNKNOWN_CHUNK = -1,
		OK = 0,
	}

	public delegate bool IsKnownFunction(ChunkType type);
	public delegate VisitorResult VisitorFunction(ChunkHeader hdr, StreamCursor cursor);

	public class ChunkVisitor {
		private bool isRoot = false;
		protected StreamCursor cursor;

		protected VisitorFunction visitor;
		protected IsKnownFunction validator;

		public VisitorResult run(){
			VisitorResult result = VisitorResult.UNKNOWN_DATA;
			while(true){
				ChunkHeader hdr = *(ChunkHeader *)(cursor.ptr);
				if(!validator(hdr.ChunkType)){
					/* 
					 * This is an unknown tag, but it's only problematic if we're in root
					 * (nothing detected this chunk and we're back to root which can't handle it either)
					 * If we're not in root, it means the child completed parsing and found a tag that it cannot handle
					 * We need to pass this to the parent's validator's loop
					 */
					result = VisitorResult.UNHANDLED_CHUNK;
					if(isRoot){
						result = VisitorResult.UNKNOWN_CHUNK;
						stderr.printf("FAILURE: Got unexpected ChunkType 0x%x, offset %lu\n",
							hdr.ChunkType,
							cursor.position
						);
					}
					stderr.printf(" == Return == \n");
					break;
				}

				cursor.skip((long)sizeof(ChunkHeader));

				ulong pre_offset = cursor.position;
				result = visitor(hdr, cursor);

				bool break_loop = false;
				switch(result){
					/*
					 * The child visitor found an unhandled chunk: ignore the error
					 * (we're the parent, we process this on the next loop)
					 */
					case VisitorResult.UNHANDLED_CHUNK:
						stderr.printf(" == Return to parent ==\n");
						break;
					case VisitorResult.UNKNOWN_DATA:
						if(!isRoot){
							stderr.printf("FAILURE: Got unexpected data in ChunkType 0x%x, offset %lu. Skipping chunk (%lu bytes)\n",
								hdr.ChunkType, cursor.position, hdr.ChunkSize
							);
							cursor.seek((long)(pre_offset + hdr.ChunkSize), SeekType.SET);
						}
						break;
					
				}

				if(break_loop)
					break;
					
				stdout.printf("Visitor: pre: %lu, post: %lu\n", pre_offset, cursor.position);
				ulong distance = cursor.position - pre_offset;
				
				/* 
				 * Check if the visitor left something behind
				 * Don't skip if the visitor didn't handle it
				 */
				if(!isRoot && result != VisitorResult.UNHANDLED_CHUNK){
					if(distance < hdr.ChunkSize){
						ulong maxSize = hdr.ChunkSize;
						if(maxSize > cursor.data.length){
							maxSize = cursor.data.length;
						}
						ulong remaining = maxSize - distance;
						stderr.printf("WARNING: Skipping trailing %lu bytes (total: %lu)\n", remaining, maxSize);
						cursor.skip((long)remaining);
					}
				}

				// If we reached EOF, stop
				if(cursor.position >= cursor.data.length){
					break;
				}
			}
			return result;
		}

		public ChunkVisitor(StreamCursor cursor, bool isRoot = false){
			this.cursor = cursor;
			this.isRoot = isRoot;
		}

		public void setup(IsKnownFunction validator, VisitorFunction visitor){
			this.validator = validator;
			this.visitor = visitor;
		}

		public void import(){
			cursor.skip_all();
		}
	}
}
