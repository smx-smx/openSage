using OpenSage;
using OpenSage.Loaders;
using OpenSage.Support;
using OpenSage.Resources.W3D.ChunkVisitors;

using Vapi.W3D;
using Vapi.W3D.Chunk;
using Vapi.W3D.HLod;

using GL;
using GLU;
using ValaGL.Core;

namespace OpenSage.Resources.W3D.Renderer {

public struct Pivot {
	string name;
	int parent;
	Vec3 angle;
	Vec3 translation;
	
	Vec4 rotation; //quaternion rotation
	Vec3 rotation_euler;
	
	bool cached;
	Mat4 model;
}
public class ModelRenderer {
	public FrameProvider provider;
	private GLProgram viewer;

	private Model model;
	private Pivot[] pivots;

	private float t = 0;
	private float angle = 0.0f;
	private Camera camera;

	//MeshRenderers
	private MeshRenderer[] mrs;

	public ModelRenderer(Model model){
		this.model = model;
		this.init_renderer();
		MainWindow.Handler.Chain(this.provider);
	}

	private void renderMesh(){

	}

	private void computePose(){
		//Loop through all pivots
		for(uint i=0; i<pivots.length; i++){
			Pivot *op = &pivots[i];
			Pivot *p = op;

			stdout.printf("Computing for %s\n", p.name);

			List<Pivot?> stuff = new List<Pivot?>();

			/*
			 * Starting from this bone, traverse until we reach root (-1 / ROOTTRANSFORM)
			 * Each bone added represents a relative translation
			 * e.g 	TURRET01 -> ROOTTRANSFORM means that we do the relative placing of TURRET01 and then ROOTTRANSFORM
			 */
			Mat4 absolute = Mat4.identity();
			while(true){
				/*
				 * If we already computed the tree for this pivot, reuse it
				 * Pivots are ordered by relation, so a parent pivot will get processed and 
				 * cached first
				 */
				if(p.cached){
					stdout.printf(" Apply Cached %s\n", p.name);
					Mat4 relative = p.model;
					absolute = relative.mul_mat(ref absolute);
					break;
				}

				stdout.printf(" Apply %s\n", p.name);

				Mat4 relative = Mat4.identity();

				// Apply this bone's translation
				GeometryUtil.translate(
					ref relative,
					ref p.translation
				);

				// Apply this bone's rotation
				Mat4 rot_mat = p.rotation.to_mat4();
				relative.mul_mat(ref rot_mat);

				absolute = relative.mul_mat(ref absolute);


				// Stop if we're in ROOTTRANSFORM
				if(p.parent < 0)
					break;
				
				// Switch to this pivot's parent
				p = &pivots[p->parent];
			}

			/*
			 * Store the final matrix in the first pivot (to avoid future traversals)
			 */
			op.model = absolute;
			op.cached = true;

			stdout.printf("\n");
		}
	}
	public void render(){
		provider.onFrameStart();

		glUniform1f((GLint)viewer.uniforms["t"], t++);


		angle+=0.05f;
		if(angle > 360.0f)
			angle = 0.0f;

		foreach(MeshRenderer mr in mrs){		
			Vec3 eye = Vec3.from_data (50.0f, 0.0f, 24.0f);
			Vec3 center = Vec3.from_data (0.0f, 0.0f, 0.0f);
			Vec3 up = Vec3.from_data (0.0f, 0.0f, 1.0f);
			
			camera.look_at (
				ref eye,
				ref center,
				ref up
			);

			Mat4 model_matrix = Mat4.identity ();
			Pivot? pivot = null;
			if(mr.pivot_idx > -1){
				pivot = pivots[mr.pivot_idx];
				if(pivot.cached){
					model_matrix = pivot.model;
				}
			}

			Vec3 rotation = Vec3.from_data (0f, 0f, 1f);
			GeometryUtil.rotate (
				ref camera.view_matrix,
				angle,
				ref rotation
			);
			camera.update();

			camera.apply ((GLint)viewer.uniforms["mvp"], ref model_matrix);
			mr.render();
		}

		provider.onFrameEnd();
	}

	private void get_pivot_idx(MeshRenderer mr){
		if(model.hlod.header.LodCount < 0){
			mr.pivot_idx = -1;
			return;
		}

		foreach(unowned HLodSubObject *sobj in model.hlod.lod_array.objects){
			string name = OpenSage.Utils.chars_to_string(sobj.Name);

			if(name == mr.object_name){
				mr.pivot_idx = (int)sobj.BoneIndex;
				stdout.printf("Object %s - Pivot #%d\n", name, mr.pivot_idx);
			}
		}
	}

	private void init_renderer(){
		glEnable(GL_DEPTH_TEST);
		glDepthFunc(GL_LEQUAL);
	
		//WireFrame mode
		//glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

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
		viewer.add_uniform("diffuse");

		camera = new Camera();
		camera.set_perspective_projection (
			60f,
			(GLfloat) EngineSettings.ScreenWidth / (GLfloat) EngineSettings.ScreenHeight,
			0.1f,
			100.0f
		);


		ImageLoader ildr = new ImageLoader();
		if(!ildr.load(EngineSettings.RootDir + "/avpaladin.dds")){
			stderr.printf("Texture load failed\n");
			return;
		}
		ValaGL.Core.Texture texture = ildr.get_frame();
		//Init mesh renderers
		uint nMeshes = model.meshes.length();
		mrs = new MeshRenderer[nMeshes];
		for(uint i=0; i<nMeshes; i++){
			mrs[i] = new MeshRenderer(viewer, model.meshes.nth_data(i));
			mrs[i].texture = texture;
			get_pivot_idx(mrs[i]);
		}


		pivots = new Pivot[model.hierarchy.header.NumPivots];
		// Process Bones (Pivots) from Hierarchy
		for(uint i=0; i<model.hierarchy.pivots.length; i++){
			Vapi.W3D.HTree.Pivot pivot = model.hierarchy.pivots[i];
			//OpenSage.Utils.hexdump((void *)&pivot, sizeof(Vapi.W3D.HTree.Pivot));


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
			/* W3D quaternions use wxyz order */
			Vec4 rotation = Vec4.from_data(
				pivot.Rotation.w,
				pivot.Rotation.x,
				pivot.Rotation.y,
				pivot.Rotation.z
			);

			/*
			 * Each bone contains a translation, a rotation and an angle
			 * It seems it contains both an EulerAngles and a Quaternion for the rotation
			 */
			Pivot p = Pivot();
			p.parent = (int)pivot.ParentIdx;
			p.angle = angle;
			p.translation = translate;
			p.rotation = rotation;
			p.cached = false;
			
			p.name = OpenSage.Utils.chars_to_string(pivot.Name);
			stdout.printf("Pivot %u: %s\n", i, p.name);

			pivots[i] = p;
		}

		computePose();

		provider = new FrameProvider();
		provider.render_func = this.render;
	}

}

}