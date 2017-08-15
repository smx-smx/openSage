using OpenSage.Support;

//using CGlm;
using Vapi.W3D;
using Vapi.W3D.Chunk;
using Vapi.W3D.Mesh;

//renderer
using GL;
using OpenSage.Loaders;
using ValaGL.Core;
//end renderer

namespace OpenSage.Resources.W3D.ChunkVisitors {
	private struct BufferItem {
		Vector3 position;
		Vector3 normal;
		TextureCoordinates texcoords;
	}

	public class MeshVisitor : ChunkVisitor {
		public Vapi.W3D.HTree.Hierarchy *hierarchy;
		

		public MeshHeader3 *header;
		public unowned Vector3[] vertices;
		public unowned Vector3[] vertices_normals;
		public unowned Triangle[] triangles;

		public VertexMaterialsVisitor vertex_materials;
		public TexturesVisitor textures;
		public MaterialPassVisitor material_pass;
		public HLodVisitor hlod;

		private VBO mesh_vbo;
		private IBO mesh_ibo;
		private ImageLoader ildr = new ImageLoader();
		private ValaGL.Core.Texture texture;

		public void render(){
			if(header.NumVertices != 119)
				return;

			// Mark the shape's VBO and IBO as current
			mesh_vbo.make_current();
			mesh_ibo.make_current();

			
			glActiveTexture(GL_TEXTURE0);
			texture.make_current();
			glUniform1i((GLint)viewer.uniforms["diffuse"], 0);

			// Then render their contents
			glDrawElements(
				GL_TRIANGLES,
				(GLsizei)(header.NumTris * 3), // number of indices
				GL_UNSIGNED_SHORT, // format of each index
				null
			);
		}
		

		private GLProgram viewer;

		public void init_renderer(GLProgram viewer){
			this.viewer = viewer;

			if(header.NumVertices != 119){
				return;
			}

			if(!ildr.load(EngineSettings.RootDir + "/avpaladin.dds")){
				stderr.printf("Texture load failed\n");
				return;
			}
			texture = ildr.get_frame();

			// VBO (vertices)
			BufferItem[] items = new BufferItem[header.NumVertices];
			//Memory.set(items, 0x00, sizeof(BufferItem) * items.length);

			for(uint i=0; i<header.NumVertices; i++){
				items[i].position = vertices[i];
				items[i].normal = vertices_normals[i];
				items[i].texcoords = material_pass.texture_stage.texcoords[i];
			}

			stdout.printf("We have %u vertices\n", header.NumVertices);

			try {
				// Make a VBO and load data into it
				mesh_vbo = new VBO((void *)items, sizeof(BufferItem) * items.length);
			} catch(CoreError err){
				stderr.printf("Failed to create VBO\n");
			}
			mesh_vbo.make_current();

			//for offset calculation
			BufferItem dummy = BufferItem();

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
			GLushort[] indices = new GLushort[header.NumTris * 3];
			uint i_tris = 0;
			uint i_idx = 0;
			
			for(; i_idx<header.NumTris * 3; i_tris++){
				// Process this triangle's indices
				for(uint tris_idx=0; tris_idx<3; tris_idx++, i_idx++){
					indices[i_idx] = (GLushort)triangles[i_tris].Vindex[tris_idx];
				}
			}

			try {
				mesh_ibo = new IBO((void *)indices, sizeof(GLushort) * indices.length * 3);
			} catch(CoreError err){
				stderr.printf("IBO creation failed\n");
			}

			mesh_ibo.make_current();
		}

		public MeshVisitor(StreamCursor cursor){
			base(cursor);
			base.setup(isKnown, visit);
			//visitor = new ChunkVisitor(ptr, isKnown, visit);
		}

		public bool isKnown(ChunkType type){
			switch(type){
				case ChunkType.VERTICES:
				case ChunkType.VERTEX_NORMALS:
				case ChunkType.MESH_USER_TEXT:
				case ChunkType.VERTEX_INFLUENCES:
				case ChunkType.MESH_HEADER3:
				case ChunkType.TRIANGLES:
				case ChunkType.VERTEX_SHADE_INDICES:
				case ChunkType.PRELIT_UNLIT:
				case ChunkType.PRELIT_VERTEX:
				case ChunkType.PRELIT_LIGHTMAP_MULTI_PASS:
				case ChunkType.PRELIT_LIGHTMAP_MULTI_TEXTURE:
				case ChunkType.MATERIAL_INFO:
				case ChunkType.VERTEX_MATERIALS:
				case ChunkType.SHADERS:
				case ChunkType.TEXTURES:
				case ChunkType.MATERIAL_PASS:
				case ChunkType.HLOD:
					return true;
				default:
					return false;
			}
		}

		private VisitorResult visit(ChunkHeader hdr, StreamCursor cursor){
			switch(hdr.ChunkType){
				case ChunkType.VERTICES:
					stdout.printf("[MESH] => Vertices\n");
					vertices = (Vector3[])(cursor.ptr);
					vertices.length = (int)header.NumVertices;
					cursor.skip((long)sizeof(Vector3) * header.NumVertices);
					return VisitorResult.OK;
				case ChunkType.VERTEX_NORMALS:
					stdout.printf("[MESH] => Vertex Normals\n");
					vertices_normals = (Vector3[])(cursor.ptr);
					vertices_normals.length = (int)header.NumVertices;
					cursor.skip((long)sizeof(Vector3) * header.NumVertices);
					return VisitorResult.OK;
				case ChunkType.MESH_USER_TEXT:
					stdout.printf("[MESH] => User Text\n");
					return VisitorResult.OK;
				case ChunkType.VERTEX_INFLUENCES:
					stdout.printf("[MESH] => Vertex Influences\n");
					return VisitorResult.OK;
				case ChunkType.MESH_HEADER3:
					header = (MeshHeader3 *)(cursor.ptr);
					stdout.printf("[MESH] => Header\n");
					return VisitorResult.OK;
				case ChunkType.TRIANGLES:
					stdout.printf("[MESH] => Triangles\n");
					triangles = (Triangle[])(cursor.ptr);
					triangles.length = (int)header.NumTris;
					cursor.skip((long)sizeof(Triangle) * header.NumTris);
					return VisitorResult.OK;
				case ChunkType.VERTEX_SHADE_INDICES:
					stdout.printf("[MESH] => Shade Indices\n");
					return VisitorResult.OK;
				case ChunkType.PRELIT_UNLIT:
					stdout.printf("[MESH] => Prelit Unlit\n");
					return VisitorResult.OK;
				case ChunkType.PRELIT_VERTEX:
					stdout.printf("[MESH] => Prelit Vertex\n");
					return VisitorResult.OK;
				case ChunkType.PRELIT_LIGHTMAP_MULTI_PASS:
					stdout.printf("[MESH] => Ligthmap - Multi Pass\n");
					return VisitorResult.OK;
				case ChunkType.PRELIT_LIGHTMAP_MULTI_TEXTURE:
					stdout.printf("[MESH] => Lightmap - Multi Texture\n");
					return VisitorResult.OK;
				case ChunkType.MATERIAL_INFO:
					stdout.printf("[MESH] => Material Info\n");
					return VisitorResult.OK;
				case ChunkType.VERTEX_MATERIALS:
					stdout.printf("[MESH] => Vertex Materials\n");
					vertex_materials = new VertexMaterialsVisitor(cursor);
					return vertex_materials.run();
				case ChunkType.SHADERS:
					stdout.printf("[MESH] => Shaders\n");
					return VisitorResult.OK;
				case ChunkType.TEXTURES:
					stdout.printf("[MESH] => Textures\n");
					textures = new TexturesVisitor(cursor);
					return textures.run();
				case ChunkType.MATERIAL_PASS:
					stdout.printf("[MESH] => Material Pass\n");
					material_pass = new MaterialPassVisitor(cursor);
					return material_pass.run();
				case ChunkType.HLOD:
					stdout.printf("[MODEL] => HLod\n");
					hlod = new HLodVisitor(cursor);
					return hlod.run();

			}
			return VisitorResult.UNKNOWN_DATA;
		}
	}
}
