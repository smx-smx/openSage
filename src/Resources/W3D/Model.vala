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

		public FrameProvider renderer;
		
		private VAO modelVao;

		private Bone[] bones;

		private GLProgram viewer;
		private float t = 0;
		private float angle = 0.0f;
		private Camera camera;

		public void render(){
			renderer.onFrameStart();
	
			glUniform1f((GLint)viewer.uniforms["t"], t++);


			angle+=0.05f;
			if(angle > 360.0f)
				angle = 0.0f;

			foreach(MeshVisitor mv in meshes){
				if(mv.header.NumVertices != 238){
					continue;
				}
				
				Vec3 eye = Vec3.from_data (20.0f, 0.0f, 25.0f);
				Vec3 center = Vec3.from_data (0.0f, 0.0f, 0.0f);
				Vec3 up = Vec3.from_data (0.0f, 0.0f, 1.0f);
				
				camera.look_at (
					ref eye,
					ref center,
					ref up
				);
	
				Mat4 model_matrix = Mat4.identity ();
	
				Vec3 rotation = Vec3.from_data (0, 0, 1);
				GeometryUtil.rotate (
					ref model_matrix,
					angle,
					ref rotation
				);

				camera.apply ((GLint)viewer.uniforms["mvp"], ref model_matrix);
				mv.render();
			}

			renderer.onFrameEnd();
		}

		public Model(uint8[] data){
			StreamCursor cursor = new StreamCursor(data);

			base(cursor, true);
			base.setup(isKnown, visit);
			this.data = data;
			base.run();
		}

		public void init_renderer(){
			modelVao = new VAO();
			glEnable(GL_DEPTH_TEST);
			glDepthFunc(GL_ALWAYS);

			glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

			try {
				viewer = new GLProgram(
					EngineSettings.RootDir + "/shaders/w3d_view.vert",
					EngineSettings.RootDir + "/shaders/w3d_view.frag"
				);
			} catch(CoreError err){
				stderr.printf("OpenGL program creation failed\n");
				throw err;
			}

			viewer.make_current();
			viewer.add_uniform("t");
			viewer.add_uniform("mvp");

			camera = new Camera();
			camera.set_perspective_projection (
				50f,
				(GLfloat) EngineSettings.ScreenWidth / (GLfloat) EngineSettings.ScreenHeight,
				0.1f,
				100.0f
			);

			foreach(MeshVisitor mv in meshes){
				mv.init_renderer();
			}

			#if false
			bones = new Bone[hierarchy.header.NumPivots];
			// Process Bones (Pivots) from Hierarchy
			foreach(Vapi.W3D.HTree.Pivot pivot in hierarchy.pivots){
				stdout.printf("Pivot: %.*s\n", NAME_LEN, pivot.Name);

				Vec3 angle = Vec3.from_data(
					pivot.EulerAngles.x,
					pivot.EulerAngles.y,
					pivot.EulerAngles.z
				);
				Vec3 translate = Vec3.from_data(
					pivot.Translation.x,
					pivot.Translation.y,
					pivot.Translation.z
				);
				Vec4 rotation = Vec4.from_data(
					pivot.Rotation.x,
					pivot.Rotation.y,
					pivot.Rotation.z,
					pivot.Rotation.w
				);

				/*
				string pivotName = (string)pivot.Name;
				pivotName[NAME_LEN - 1] = 0x00;
				*/

				Bone b = Bone();
				b.parent = pivot.ParentIdx;
				b.angle = angle;
				b.transform = translate;
				b.rotation = rotation;

				bones += b;
			}
			#endif

			renderer = new FrameProvider();
			renderer.render_func = this.render;
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
