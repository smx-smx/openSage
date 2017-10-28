using OpenSage;
using OpenSage.Loaders;
using OpenSage.Support;
using OpenSage.Resources.W3D.ChunkVisitors;

using Vapi.W3D;
using Vapi.W3D.Chunk;
using Vapi.W3D.HLod;

using GL;
using ValaGL.Core;
using Gee;


namespace OpenSage.Resources.W3D.Renderer {

private struct BufferItem {
	Vector3 position;
	Vector3 normal;
	TextureCoordinates texcoords;
}

private class FaceGroup {
	public int numIndices;
	public ValaGL.Core.Texture? texture; //can be null
	public VBO vbo;
	public IBO ibo;

	public BufferItem[]? group_items;
	public GLushort[]? indices;
	public int ibo_offset;

	public void render(GLProgram viewer){
		vbo.make_current();
		//ibo.make_current();

		if(texture != null){
			glUniform1i((GLint)viewer.uniforms["texture"], 0);
			texture.make_current(0);
		}

		// Then render their contents
		/*
		 * null as last argument indicates indices
		 * should be retrived from the current IBO
		 * */
		 glDrawElementsBaseVertex(
			GL_TRIANGLES,
			(GLsizei)(indices.length), // number of indices
			GL_UNSIGNED_SHORT, // format of each index
			null,
			ibo_offset
		);
	}
}

public class MeshRenderer {
	public unowned MeshVisitor mesh;
	private GLProgram viewer;
	
	private VAO mesh_vao;
	private VBO mesh_vbo;
	private IBO mesh_ibo;

	private bool has_textures;
	private bool has_multi_textures;

	private ValaGL.Core.Texture[] textures;
	private ImageLoader ildr = new ImageLoader();
	private HashMap<int, FaceGroup*> faceGroups = new HashMap<int, FaceGroup*>();

	public unowned Pivot? pivot = null;

	public bool is_skinned = false;

	public int pivot_idx = -1;
	public string object_name;

	private int ibo_start;

	/* container.mesh, e.g AVPALADIN.CHASSIS */
	private string get_object_name(){
		string containerName = OpenSage.Utils.chars_to_string(mesh.header.ContainerName);
		string meshName = OpenSage.Utils.chars_to_string(mesh.header.MeshName);
		return containerName + "." + meshName;
	}

	public MeshRenderer(GLProgram viewer, MeshVisitor mv){
		this.viewer = viewer;
		this.mesh = mv;

		this.object_name = get_object_name();
		if(MeshFlags.SKIN in mesh.header.Attributes){
			stdout.printf("!!Skinned = true!!\n");
			is_skinned = true;
		}

		this.init_renderer();
	}

	public void render(){
		mesh_vao.make_current();	
		
		if(!has_multi_textures){
			mesh_vbo.make_current();
			//mesh_ibo.make_current();

			if(has_textures)
				textures[0].make_current(0);

			glDrawElements(
				GL_TRIANGLES,
				(GLsizei)(mesh.header.NumTris * 3), // number of indices
				GL_UNSIGNED_SHORT, // format of each index
				null
			);
		}
		foreach(FaceGroup *fg in faceGroups.values){
			fg->render(viewer);
		}
	}

	private ValaGL.Core.Texture? loadTexture(TextureVisitor tv){
		string textureName = tv.texture_name.down();
		int ext_pos = textureName.last_index_of_char('.');
		if(ext_pos > -1){
			textureName = textureName.splice(ext_pos, textureName.length);
		}

		unowned uint8[]? textureBuf = null;
		string[] extensions = {"dds", "tga"};
		string texturePath = null;
		foreach(string ext in extensions){
			StringBuilder sb = new StringBuilder();
			sb.append_printf("art/textures/%s.%s", textureName, ext);
			texturePath = sb.str;

			textureBuf = Engine.BigLoader.getFile(texturePath);
			stdout.printf(" -- %s Texture -- %s\n", object_name, textureName);

			if(textureBuf != null){
				break;
			}
		}

		if(textureBuf == null){
			throw new SageError.GENERIC("Failed to load texture %s\n", texturePath);
		}
		
		return ImageLoader.LoadStream(textureBuf);
	}

	private FaceGroup *getFaceGroup(int texture_index){
		if(!faceGroups.has_key(texture_index)){
			// Allocate new
			stdout.printf("=> New FaceGroup for %d\n", texture_index);
			FaceGroup *fg = new FaceGroup();
			fg->group_items = new BufferItem[0];
			fg->indices = new GLushort[0];
			faceGroups[texture_index] = fg;
		}
		return faceGroups[texture_index];
	}

	private void initVbo(VBO vbo){
		//for offset calculation
		BufferItem dummy = BufferItem();

		vbo.make_current();
		/*
		* Specify the components we are passing through the buffer
		*/
		vbo.add_attribute(
			0, //index
			3, //number of vector components
			GL_FLOAT, //type of elements
			GL_FALSE, //values should not be normalized
			sizeof(BufferItem), //distance to the next element
			(uintptr)&dummy.position - (uintptr)&dummy //offset of the item
		);

		// Index 1 -> vertex normals
		vbo.add_attribute(
			1,
			3,
			GL_FLOAT,
			GL_FALSE,
			sizeof(BufferItem),
			(uintptr)&dummy.normal - (uintptr)&dummy
		);

		// Index 2 -> vertex texture coords
		vbo.add_attribute(
			2,
			2,
			GL_FLOAT,
			GL_FALSE,
			sizeof(BufferItem),
			(uintptr)&dummy.texcoords - (uintptr)&dummy
		);
	}

	private void init_renderer(){
		// VAO
		mesh_vao = new VAO();
		mesh_vao.make_current();

		// VBO (vertices)
		BufferItem[] items = new BufferItem[mesh.header.NumVertices];
		//Memory.set(items, 0x00, sizeof(BufferItem) * items.length);

		#if W3D_DEBUG
		stdout.printf(" ---- %s Vertices ----\n", object_name);
		foreach(Vector3 position in mesh.vertices){
			stdout.printf("Vec3(%.6f, %.6f, %.6f)\n", position.x, position.y, position.z);
		}
		#endif

		
		has_textures = 
			mesh.material_pass.texture_stage != null &&
			mesh.material_pass.texture_stage.texcoords != null;

		has_multi_textures = has_textures && mesh.material_pass.texture_stage.ids.length > 1;

		glUniform1i((GLint)viewer.uniforms["has_texture"], (GLint)(has_textures));

		if(has_textures){
			int numTextures = mesh.textures.textures.size;
			textures = new ValaGL.Core.Texture[numTextures];
			// Load textures
			for(int i=0; i<numTextures; i++){
				TextureVisitor tv = mesh.textures.textures[i];
				ValaGL.Core.Texture? texture = loadTexture(tv);
				textures[i] = texture;
			}
		}

		if(has_textures && has_multi_textures){
			// Mapping between a face (triangle) and a texture
			unowned int32[] stage_ids = mesh.material_pass.texture_stage.ids;
			for(int i_tris=0; i_tris<stage_ids.length; i_tris++){
				int texture_index = stage_ids[i_tris];
				
				//if(i_tris == 395)
				//assert(texture_index == 15);

				FaceGroup fg = getFaceGroup(texture_index);

				
				assert(i_tris < mesh.header.NumTris);

				fg.texture = textures[texture_index];

				// Get the face (triangle)
				Triangle tris = mesh.triangles[i_tris];
				// Process the indices to extract the vertices
				for(int idx=0; idx<3; idx++){
					GLushort vindex = (GLushort)tris.Vindex[idx];
					assert(vindex < mesh.header.NumVertices);
					
					fg.indices += vindex;

					BufferItem itm = {};
					itm.position = mesh.vertices[vindex];
					itm.normal = mesh.vertices_normals[vindex];
					itm.texcoords = mesh.material_pass.texture_stage.texcoords[vindex];

					fg.group_items += itm;
				}
			}

			GLushort[] indices = new GLushort[mesh.header.NumTris * 3];
			for(uint i_tris=0, i_idx=0; i_idx<mesh.header.NumTris * 3; i_tris++){
				// Process this triangle's indices
				for(uint tris_idx=0; tris_idx<3; tris_idx++, i_idx++){
					indices[i_idx] = (GLushort)mesh.triangles[i_tris].Vindex[tris_idx];

					#if W3D_DEBUG
					stdout.printf("%u", indices[i_idx]);
					if(i_idx + 1 < mesh.header.NumTris * 3)
						stdout.printf(",");
					#endif
				}
			}
			try {
				mesh_ibo = new IBO((void *)indices, sizeof(GLushort) * indices.length);
			} catch(CoreError err){
				stderr.printf("IBO creation failed\n");
			}
			mesh_ibo.make_current();
			

			foreach(FaceGroup *fg in faceGroups){
				try {;
					stdout.printf("Make VBO with %d elements\n", fg->group_items.length);
					fg->vbo = new VBO((void *)fg->group_items, sizeof(BufferItem) * fg->group_items.length);
				} catch(CoreError err){
					stderr.printf("Failed to create VBO\n");
				}
				initVbo(fg->vbo);

				/*try {
					stdout.printf("Make IBO with %d elements\n", fg->indices.length);
					fg->ibo = new IBO((void *)indices[ibo_start], sizeof(GLushort) * fg->group_items.length * 3);
				} catch(CoreError err){
					stderr.printf("Failed to create IBO\n");
				}*/

				fg->ibo_offset = ibo_start;

				ibo_start += fg->group_items.length * 3;
			}
		} else {
			for(uint i=0; i<mesh.header.NumVertices; i++){
				items[i].position = mesh.vertices[i];
				items[i].normal = mesh.vertices_normals[i];
				if(has_textures)
					items[i].texcoords = mesh.material_pass.texture_stage.texcoords[i];
			}
			try {
				// Make a VBO and load data into it
				mesh_vbo = new VBO((void *)items, sizeof(BufferItem) * items.length);
			} catch(CoreError err){
				stderr.printf("Failed to create VBO\n");
			}
			initVbo(mesh_vbo);
	
			// IBO (indices)
			// Load triangles indices: each triangle has 3
			GLushort[] indices = new GLushort[mesh.header.NumTris * 3];
			uint i_tris = 0;
			uint i_idx = 0;
			
			#if W3D_DEBUG
			stdout.printf(" ---- %s Indices ----\n", object_name);
			#endif

			for(; i_idx<mesh.header.NumTris * 3; i_tris++){
				// Process this triangle's indices
				for(uint tris_idx=0; tris_idx<3; tris_idx++, i_idx++){
					indices[i_idx] = (GLushort)mesh.triangles[i_tris].Vindex[tris_idx];

					#if W3D_DEBUG
					stdout.printf("%u", indices[i_idx]);
					if(i_idx + 1 < mesh.header.NumTris * 3)
						stdout.printf(",");
					#endif
				}
			}

			#if W3D_DEBUG
			stdout.printf("\n");
			#endif

			try {
				mesh_ibo = new IBO((void *)indices, sizeof(GLushort) * indices.length);
			} catch(CoreError err){
				stderr.printf("IBO creation failed\n");
			}

			mesh_ibo.make_current();
		}	
	}
}

}