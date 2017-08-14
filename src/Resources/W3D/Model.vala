using OpenSage.Loaders;
using OpenSage.Support;
using OpenSage.Resources.W3D.ChunkVisitors;

using Vapi.W3D;
using Vapi.W3D.Chunk;

using GL;
using GLU;
using ValaGL.Core;

namespace OpenSage.Resources.W3D {
	private struct Bone {
		uint32 parent;
		Vec3 angle;
		Vec3 transform;
		Vec4 rotation; //quaternion rotation
	}

	public class Model : ChunkVisitor {
		private unowned uint8[] data;

		public HierarchyVisitor hierarchy;
		public AnimationVisitor animation;
		
		public List<MeshVisitor> meshes = new List<MeshVisitor>();

		private Bone[] bones;

		public Model(uint8[] data){
			StreamCursor cursor = new StreamCursor(data);

			base(cursor, true);
			base.setup(isKnown, visit);
			this.data = data;
			base.run();
		}

		private bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.MESH:
				case ChunkType.HIERARCHY:
				case ChunkType.ANIMATION:
				case ChunkType.COMPRESSED_ANIMATION:
				case ChunkType.MORPH_ANIMATION:
				case ChunkType.HMODEL:
				case ChunkType.LODMODEL:
				case ChunkType.COLLECTION:
				case ChunkType.POINTS:
				case ChunkType.LIGHT:
				case ChunkType.EMITTER:
				case ChunkType.AGGREGATE:
				case ChunkType.BOX:
				case ChunkType.SPHERE:
				case ChunkType.RING:
				case ChunkType.NULL_OBJECT:
				case ChunkType.LIGHTSCAPE:
				case ChunkType.DAZZLE:
				case ChunkType.SOUNDROBJ:
					return true;
				default:
					return false;
			}
		}

		private VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.MESH:
					stdout.printf("[MODEL] => Mesh\n");
					MeshVisitor mesh = new MeshVisitor(cursor);
					meshes.append(mesh);
					return mesh.run();
				case ChunkType.HIERARCHY:
					stdout.printf("[MODEL] => Hierarchy\n");
					hierarchy = new HierarchyVisitor(cursor);
					return hierarchy.run();
				case ChunkType.ANIMATION:
					stdout.printf("[MODEL] => Animation\n");
					animation = new AnimationVisitor(cursor);
					return animation.run();
				case ChunkType.COMPRESSED_ANIMATION:
					stdout.printf("[MODEL] => Compressed Animation\n");
					break;
				case ChunkType.MORPH_ANIMATION:
					stdout.printf("[MODEL] => Morph Animation\n");
					break;
				case ChunkType.HMODEL:
					stdout.printf("[MODEL] => HModel\n");
					break;
				case ChunkType.LODMODEL:
					stdout.printf("[MODEL] => LOD Model\n");
					break;
				case ChunkType.COLLECTION:
					stdout.printf("[MODEL] => Collection\n");
					break;
				case ChunkType.POINTS:
					stdout.printf("[MODEL] => Points\n");
					break;
				case ChunkType.LIGHT:
					stdout.printf("[MODEL] => Light\n");
					break;
				case ChunkType.EMITTER:
					stdout.printf("[MODEL] => Emitter\n");
					break;
				case ChunkType.AGGREGATE:
					stdout.printf("[MODEL] => Aggregate\n");
					break;
				case ChunkType.BOX:
					stdout.printf("[MODEL] => Box\n");
					break;
				case ChunkType.SPHERE:
					stdout.printf("[MODEL] => Sphere\n");
					break;
				case ChunkType.RING:
					stdout.printf("[MODEL] => Ring\n");
					break;
				case ChunkType.NULL_OBJECT:
					stdout.printf("[MODEL] => Null Object\n");
					break;
				case ChunkType.LIGHTSCAPE:
					stdout.printf("[MODEL] => Lightscape\n");
					break;
				case ChunkType.DAZZLE:
					stdout.printf("[MODEL] => Dazzle\n");
					break;
				case ChunkType.SOUNDROBJ:
					stdout.printf("[MODEL] => Sound RObject\n");
					break;
			}
			return VisitorResult.UNKNOWN_DATA;
		}

	}
}
