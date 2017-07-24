using OpenSage.Support;
using Vapi.W3D.Chunk;

namespace OpenSage.Resources.W3D.ChunkVisitors {
	public class MeshVisitor : ChunkVisitor {
		public Vapi.W3D.HTree.Hierarchy *hierarchy;
		public unowned Vapi.W3D.HTree.Pivot[] pivots;
		public unowned Vapi.W3D.HTree.PivotFixup[] pivotsFixups;

		public VertexMaterialsVisitor vertex_materials;
		public TexturesVisitor textures;
		public MaterialPassVisitor material_pass;
		public HLodVisitor hlod;

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
					return VisitorResult.OK;
				case ChunkType.VERTEX_NORMALS:
					stdout.printf("[MESH] => Vertex Normals\n");
					return VisitorResult.OK;
				case ChunkType.MESH_USER_TEXT:
					stdout.printf("[MESH] => User Text\n");
					return VisitorResult.OK;
				case ChunkType.VERTEX_INFLUENCES:
					stdout.printf("[MESH] => Vertex Influences\n");
					return VisitorResult.OK;
				case ChunkType.MESH_HEADER3:
					stdout.printf("[MESH] => Header\n");
					return VisitorResult.OK;
				case ChunkType.TRIANGLES:
					stdout.printf("[MESH] => Triangles\n");
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
