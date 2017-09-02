using OpenSage;
using OpenSage.Loaders;
using OpenSage.Support;
using OpenSage.Resources.W3D.ChunkVisitors;

using Vapi.W3D;
using Vapi.W3D.Chunk;
using Vapi.W3D.HLod;

using GL;
using ValaGL.Core;


namespace OpenSage.Resources.W3D.Renderer {

private struct BufferItem {
	Vector3 position;
	Vector3 normal;
	TextureCoordinates texcoords;
}

public class MeshRenderer {
	public unowned MeshVisitor mesh;
	private GLProgram viewer;
	
	private VAO mesh_vao;
	private VBO mesh_vbo;
	private IBO mesh_ibo;

	private ImageLoader ildr = new ImageLoader();
	public ValaGL.Core.Texture texture;

	public unowned Pivot? pivot = null;

	public bool is_skinned = false;

	public int pivot_idx = -1;
	public string object_name;

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
		mesh_vbo.make_current();
		mesh_ibo.make_current();
	
		glActiveTexture(GL_TEXTURE0);
		if(texture != null)
			texture.make_current();
		glUniform1i((GLint)viewer.uniforms["diffuse"], 0);

		// Then render their contents
		/*
		 * null as last argument indicates indices
		 * should be retrived from the current IBO
		 * */
		glDrawElements(
			GL_TRIANGLES,
			(GLsizei)(mesh.header.NumTris * 3), // number of indices
			GL_UNSIGNED_SHORT, // format of each index
			null
		);
	}

	private void init_renderer(){
		// VBO (vertices)
		BufferItem[] items = new BufferItem[mesh.header.NumVertices];
		//Memory.set(items, 0x00, sizeof(BufferItem) * items.length);

		#if W3D_DEBUG
		stdout.printf(" ---- %s Vertices ----\n", object_name);
		foreach(Vector3 position in mesh.vertices){
			stdout.printf("Vec3(%.6f, %.6f, %.6f)\n", position.x, position.y, position.z);
		}
		#endif

		
		bool has_texcoords = 
			mesh.material_pass.texture_stage != null &&
			mesh.material_pass.texture_stage.texcoords != null;

		if(has_texcoords){
			string textureName = mesh.textures.texture.texture_name.down();
			int ext_pos = textureName.last_index_of_char('.');
			if(ext_pos > -1){
				textureName = textureName.splice(ext_pos, textureName.length);
			}

			unowned uint8[]? textureBuf = null;
			string[] extensions = {"dds", "tga"};
			foreach(string ext in extensions){
				StringBuilder sb = new StringBuilder();
				sb.append_printf("art/textures/%s.%s", textureName, ext);

				textureBuf = Engine.BigLoader.getFile(sb.str);
				stdout.printf(" -- %s Texture -- %s\n", object_name, textureName);

				if(textureBuf != null)
					break;
			}

			if(textureBuf == null){
				stderr.printf("Failed to load texture\n");
				throw new SageError.GENERIC("Failed to load texture\n");
			}
			texture = ImageLoader.LoadStream(textureBuf);
		}

		for(uint i=0; i<mesh.header.NumVertices; i++){
			items[i].position = mesh.vertices[i];
			items[i].normal = mesh.vertices_normals[i];
			if(has_texcoords)
				items[i].texcoords = mesh.material_pass.texture_stage.texcoords[i];
			else
				items[i].texcoords = {0.0f, 0.0f};
		}

		try {
			// Make a VBO and load data into it
			mesh_vbo = new VBO((void *)items, sizeof(BufferItem) * items.length);
		} catch(CoreError err){
			stderr.printf("Failed to create VBO\n");
		}
		mesh_vbo.make_current();

		//for offset calculation
		BufferItem dummy = BufferItem();

		mesh_vao = new VAO();
		mesh_vao.make_current();

		/*
		* Specify the components we are passing through the buffer
		*/
		mesh_vbo.add_attribute(
			0, //index
			3, //number of vector components
			GL_FLOAT, //type of elements
			GL_FALSE, //values should not be normalized
			sizeof(BufferItem), //distance to the next element
			(uintptr)&dummy.position - (uintptr)&dummy //offset of the item
		);

		// Index 1 -> vertex normals
		mesh_vbo.add_attribute(
			1,
			3,
			GL_FLOAT,
			GL_FALSE,
			sizeof(BufferItem),
			(uintptr)&dummy.normal - (uintptr)&dummy
		);

		// Index 2 -> vertex texture coords
		mesh_vbo.add_attribute(
			2,
			2,
			GL_FLOAT,
			GL_FALSE,
			sizeof(BufferItem),
			(uintptr)&dummy.texcoords - (uintptr)&dummy
		);

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