using OpenSage.Loaders;
using OpenSage.Support;
using OpenSage.Resources.W3D.ChunkVisitors;

using Vapi.W3D;
using Vapi.W3D.Chunk;

using GL;
using GLU;
using ValaGL.Core;

namespace OpenSage.Resources.W3D {

public class Renderer {
	public FrameProvider renderer;
	private GLProgram viewer;

	private Model model;

	private VAO modelVao;

	private float t = 0;
	private float angle = 0.0f;
	private Camera camera;

	public Renderer(Model model){
		this.model = model;
		this.init_renderer();
	}

	public void render(){
		renderer.onFrameStart();

		glUniform1f((GLint)viewer.uniforms["t"], t++);


		angle+=0.05f;
		if(angle > 360.0f)
			angle = 0.0f;

		foreach(MeshVisitor mv in model.meshes){
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

		foreach(MeshVisitor mv in model.meshes){
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

}

}