[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace Vapi {
	
[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D {
	[CCode(cname = "W3D_NAME_LEN")]
	const int NAME_LEN;

	[CCode(cname = "MESH_PATH_ENTRIES")]
	const int MESH_PATH_ENTRIES;

	[CCode(cname = "MESH_PATH_ENTRY_LEN")]
	const int MESH_PATH_ENTRY_LEN;

	public struct Vector2 {
		public float x;
		public float y;
	}

	public struct Vector3 {
		public float x;
		public float y;
		public float z;
	}

	public struct Vector4 {
		public float x;
		public float y;
		public float z;
		public float w;
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.Chunk {
	[CCode(cname = "uint32", cprefix = "W3D_CHUNK_")]
	public enum ChunkType {
		MESH,
		VERTICES,
		VERTEX_NORMALS,
		MESH_USER_TEXT,
		VERTEX_INFLUENCES,
		MESH_HEADER3,
		TRIANGLES,
		VERTEX_SHADE_INDICES,
		PRELIT_UNLIT,
		PRELIT_VERTEX,
		PRELIT_LIGHTMAP_MULTI_PASS,
		PRELIT_LIGHTMAP_MULTI_TEXTURE,
		MATERIAL_INFO,
		SHADERS,
		VERTEX_MATERIALS,
		VERTEX_MATERIAL,
		VERTEX_MATERIAL_NAME,
		VERTEX_MATERIAL_INFO,
		VERTEX_MAPPER_ARGS0,
		VERTEX_MAPPER_ARGS1,
		TEXTURES,
		TEXTURE,
		TEXTURE_NAME,
		TEXTURE_INFO,
		MATERIAL_PASS,
		VERTEX_MATERIAL_IDS,
		SHADER_IDS,
		DCG,
		DIG,
		SCG,
		TEXTURE_STAGE,
		TEXTURE_IDS,
		STAGE_TEXCOORDS,
		PER_FACE_TEXCOORD_IDS,
		DEFORM,
		DEFORM_SET,
		DEFORM_KEYFRAME,
		DEFORM_DATA,
		PS2_SHADERS,
		AABTREE,
		AABTREE_HEADER,
		AABTREE_POLYINDICES,
		AABTREE_NODES,
		HIERARCHY,
		HIERARCHY_HEADER,
		PIVOTS,
		PIVOT_FIXUPS,
		ANIMATION,
		ANIMATION_HEADER,
		ANIMATION_CHANNEL,
		BIT_CHANNEL,
		COMPRESSED_ANIMATION,
		COMPRESSED_ANIMATION_HEADER,
		COMPRESSED_ANIMATION_CHANNEL,
		COMPRESSED_BIT_CHANNEL,
		MORPH_ANIMATION,
		MORPHANIM_HEADER,
		MORPHANIM_CHANNEL,
		MORPHANIM_POSENAME,
		MORPHANIM_KEYDATA,
		MORPHANIM_PIVOTCHANNELDATA,
		HMODEL,
		HMODEL_HEADER,
		NODE,
		COLLISION_NODE,
		SKIN_NODE,
		LODMODEL,
		LODMODEL_HEADER,
		LOD,
		COLLECTION,
		COLLECTION_HEADER,
		COLLECTION_OBJ_NAME,
		PLACEHOLDER,
		TRANSFORM_NODE,
		POINTS,
		LIGHT,
		LIGHT_INFO,
		SPOT_LIGHT_INFO,
		NEAR_ATTENUATION,
		FAR_ATTENUATION,
		EMITTER,
		EMITTER_HEADER,
		EMITTER_USER_DATA,
		EMITTER_INFO,
		EMITTER_INFOV2,
		EMITTER_PROPS,
		EMITTER_LINE_PROPERTIES,
		EMITTER_ROTATION_KEYFRAMES,
		EMITTER_FRAME_KEYFRAMES,
		EMITTER_BLUR_TIME_KEYFRAMES,
		AGGREGATE,
		AGGREGATE_HEADER,
		AGGREGATE_INFO,
		TEXTURE_REPLACER_INFO,
		AGGREGATE_CLASS_INFO,
		HLOD,
		HLOD_HEADER,
		HLOD_LOD_ARRAY,
		HLOD_SUB_OBJECT_ARRAY_HEADER,
		HLOD_SUB_OBJECT,
		HLOD_AGGREGATE_ARRAY,
		HLOD_PROXY_ARRAY,
		BOX,
		SPHERE,
		RING,
		NULL_OBJECT,
		LIGHTSCAPE,
		LIGHTSCAPE_LIGHT,
		LIGHT_TRANSFORM,
		DAZZLE,
		DAZZLE_NAME,
		DAZZLE_TYPENAME,
		SOUNDROBJ,
		SOUNDROBJ_HEADER,
		SOUNDROBJ_DEFINITION;
	}

	[CCode(cprefix = "OBSOLETE_W3D_CHUNK_")]
	public enum ObsoleteChunkType {
		HMODEL_AUX_DATA,
		SHADOW_NODE,
		EMITTER_COLOR_KEYFRAME,
		EMITTER_OPACITY_KEYFRAME,
		EMITTER_SIZE_KEYFRAME
	}

	[CCode(cname = "W3dChunkHeader")]
	public struct ChunkHeader {
		public ChunkType ChunkType;
		public uint32 ChunkSize;
	}

	[CCode(cname = "W3dTexCoordStruct")]
	public struct TextureCoordinates {
		public float U;
		public float V;
	}

	[CCode(cname = "W3dRGBStruct")]
	public struct RGBColor {
		public uint8 R;
		public uint8 G;
		public uint8 B;
	}

	[CCode(cname = "W3dRGBAStruct")]
	public struct RGBAColor {
		public uint8 R;
		public uint8 G;
		public uint8 B;
		public uint8 A;
	}

	[CCode(cname = "W3dMaterialInfoStruct")]
	public struct MaterialInfo {
		public uint32 PassCount;
		public uint32 VertexMaterialCount;
		public uint32 ShaderCount;
		public uint32 TextureCount;
	}

	[Flags, CCode(cprefix = "W3DVERTMAT_")]
	public enum MaterialFlags {
		USE_DEPTH_CUE,
		ARGB_EMISSIVE_ONLY,
		COPY_SPECULAR_TO_DIFFUSE,
		DEPTH_CUE_TO_ALPHA,
		STAGE0_MAPPING_MASK,
		STAGE0_MAPPING_UV,
		STAGE0_MAPPING_ENVIRONMENT,
		STAGE0_MAPPING_CHEAP_ENVIRONMENT,
		STAGE0_MAPPING_SCREEN,
		STAGE0_MAPPING_LINEAR_OFFSET,
		STAGE0_MAPPING_SILHOUETTE,
		STAGE0_MAPPING_SCALE,
		STAGE0_MAPPING_GRID,
		STAGE0_MAPPING_ROTATE,
		STAGE0_MAPPING_SINE_LINEAR_OFFSET,
		STAGE0_MAPPING_STEP_LINEAR_OFFSET,
		STAGE0_MAPPING_ZIGZAG_LINEAR_OFFSET,
		STAGE0_MAPPING_WS_CLASSIC_ENV,
		STAGE0_MAPPING_WS_ENVIRONMENT,
		STAGE0_MAPPING_GRID_CLASSIC_ENV,
		STAGE0_MAPPING_GRID_ENVIRONMENT,
		STAGE0_MAPPING_RANDOM,
		STAGE0_MAPPING_EDGE,
		STAGE0_MAPPING_BUMPENV,
		STAGE1_MAPPING_MASK,
		STAGE1_MAPPING_UV,
		STAGE1_MAPPING_ENVIRONMENT,
		STAGE1_MAPPING_CHEAP_ENVIRONMENT,
		STAGE1_MAPPING_SCREEN,
		STAGE1_MAPPING_LINEAR_OFFSET,
		STAGE1_MAPPING_SILHOUETTE,
		STAGE1_MAPPING_SCALE,
		STAGE1_MAPPING_GRID,
		STAGE1_MAPPING_ROTATE,
		STAGE1_MAPPING_SINE_LINEAR_OFFSET,
		STAGE1_MAPPING_STEP_LINEAR_OFFSET,
		STAGE1_MAPPING_ZIGZAG_LINEAR_OFFSET,
		STAGE1_MAPPING_WS_CLASSIC_ENV,
		STAGE1_MAPPING_WS_ENVIRONMENT,
		STAGE1_MAPPING_GRID_CLASSIC_ENV,
		STAGE1_MAPPING_GRID_ENVIRONMENT,
		STAGE1_MAPPING_RANDOM,
		STAGE1_MAPPING_EDGE,
		STAGE1_MAPPING_BUMPENV,
		PSX_MASK,
		PSX_TRANS_MASK,
		PSX_TRANS_NONE,
		PSX_TRANS_100,
		PSX_TRANS_50,
		PSX_TRANS_25,
		PSX_TRANS_MINUS_100,
		PSX_NO_RT_LIGHTING
	}

	[CCode(cname = "W3dVertexMaterialStruct")]
	public struct VertexMaterial {
		public uint32 Attributes;
		public W3D.Chunk.RGBColor Ambient;
		public W3D.Chunk.RGBColor Diffuse;
		public W3D.Chunk.RGBColor Specular;
		public W3D.Chunk.RGBColor Emissive;
		public float Shininess;
		public float Opacity;
		public float Translucency;
	}

	[CCode(cprefix = "W3DSHADER_")]
	public enum ShaderOptions {
		DEPTHCOMPARE_PASS_NEVER,
		DEPTHCOMPARE_PASS_LESS,
		DEPTHCOMPARE_PASS_EQUAL,
		DEPTHCOMPARE_PASS_LEQUAL,
		DEPTHCOMPARE_PASS_GREATER,
		DEPTHCOMPARE_PASS_NOTEQUAL,
		DEPTHCOMPARE_PASS_GEQUAL,
		DEPTHCOMPARE_PASS_ALWAYS,
		DEPTHCOMPARE_PASS_MAX,
		DEPTHMASK_WRITE_DISABLE,
		DEPTHMASK_WRITE_ENABLE,
		DEPTHMASK_WRITE_MAX,
		ALPHATEST_DISABLE,
		ALPHATEST_ENABLE,
		ALPHATEST_MAX,
		DESTBLENDFUNC_ZERO,
		DESTBLENDFUNC_ONE,
		DESTBLENDFUNC_SRC_COLOR,
		DESTBLENDFUNC_ONE_MINUS_SRC_COLOR,
		DESTBLENDFUNC_SRC_ALPHA,
		DESTBLENDFUNC_ONE_MINUS_SRC_ALPHA,
		DESTBLENDFUNC_SRC_COLOR_PREFOG,
		DESTBLENDFUNC_MAX,
		PRIGRADIENT_DISABLE,
		PRIGRADIENT_MODULATE,
		PRIGRADIENT_ADD,
		PRIGRADIENT_BUMPENVMAP,
		PRIGRADIENT_MAX,
		SECGRADIENT_DISABLE,
		SECGRADIENT_ENABLE,
		SECGRADIENT_MAX,
		SRCBLENDFUNC_ZERO,
		SRCBLENDFUNC_ONE,
		SRCBLENDFUNC_SRC_ALPHA,
		SRCBLENDFUNC_ONE_MINUS_SRC_ALPHA,
		SRCBLENDFUNC_MAX,
		TEXTURING_DISABLE,
		TEXTURING_ENABLE,
		TEXTURING_MAX,
		DETAILCOLORFUNC_DISABLE,
		DETAILCOLORFUNC_DETAIL,
		DETAILCOLORFUNC_SCALE,
		DETAILCOLORFUNC_INVSCALE,
		DETAILCOLORFUNC_ADD,
		DETAILCOLORFUNC_SUB,
		DETAILCOLORFUNC_SUBR,
		DETAILCOLORFUNC_BLEND,
		DETAILCOLORFUNC_DETAILBLEND,
		DETAILCOLORFUNC_MAX,
		DETAILALPHAFUNC_DISABLE,
		DETAILALPHAFUNC_DETAIL,
		DETAILALPHAFUNC_SCALE,
		DETAILALPHAFUNC_INVSCALE,
		DETAILALPHAFUNC_MAX,
		DEPTHCOMPARE_DEFAULT,
		DEPTHMASK_DEFAULT,
		ALPHATEST_DEFAULT,
		DESTBLENDFUNC_DEFAULT,
		PRIGRADIENT_DEFAULT,
		SECGRADIENT_DEFAULT,
		SRCBLENDFUNC_DEFAULT,
		TEXTURING_DEFAULT,
		DETAILCOLORFUNC_DEFAULT,
		DETAILALPHAFUNC_DEFAULT
	}

	[CCode(cprefix = "PSS_")]
	public enum PS2ShaderSettings {
		SRC,
		DEST,
		ZERO,
		SRC_ALPHA,
		DEST_ALPHA,
		ONE,
		PRIGRADIENT_DECAL,
		PRIGRADIENT_MODULATE,
		PRIGRADIENT_HIGHLIGHT,
		PRIGRADIENT_HIGHLIGHT2,
		PS2_PRIGRADIENT_MODULATE,
		PS2_PRIGRADIENT_DECAL,
		PS2_PRIGRADIENT_HIGHLIGHT,
		PS2_PRIGRADIENT_HIGHLIGHT2,
		DEPTHCOMPARE_PASS_NEVER,
		DEPTHCOMPARE_PASS_LESS,
		DEPTHCOMPARE_PASS_ALWAYS,
		DEPTHCOMPARE_PASS_LEQUAL,
	}

	[CCode(cname = "W3dShaderStruct")]
	public struct Shader {
		public uint8 DepthCompare;
		public uint8 DepthMask;
		public uint8 ColorMask;
		public uint8 DestBlend;
		public uint8 FogFunc;
		public uint8 PriGradient;
		public uint8 SecGradient;
		public uint8 SrcBlend;
		public uint8 Texturing;
		public uint8 DetailColorFunc;
		public uint8 DetailAlphaFunc;
		public uint8 ShaderPreset;
		public uint8 AlphaTest;
		public uint8 PostDetailColorFunc;
		public uint8 PostDetailAlphaFunc;
	}

	[Flags, CCode(cprefix = "W3DTEXTURE_")]
	public enum TextureFlags {
		PUBLISH,
		RESIZE_OBSOLETE,
		NO_LOD,
		CLAMP_U,
		CLAMP_V,
		ALPHA_BITMAP,
		MIP_LEVELS_MASK,
		MIP_LEVELS_ALL,
		MIP_LEVELS_2,
		MIP_LEVELS_3,
		MIP_LEVELS_4,
		HINT_SHIFT,
		HINT_MASK,
		HINT_BASE,
		HINT_EMISSIVE,
		HINT_ENVIRONMENT,
		HINT_SHINY_MASK,
		TYPE_MASK,
		TYPE_COLORMAP,
		TYPE_BUMPMAP,
		ANIM_LOOP,
		ANIM_PINGPONG,
		ANIM_ONCE,
		ANIM_MANUAL
	}

	[CCode(cname = "W3dTextureInfoStruct")]
	public struct TextureInfo {
		public uint16 Attributes;
		public uint16 AnimType;
		public uint32 FrameCount;
		public float FrameRate;
	}

	[CCode(cname = "W3dTriStruct")]
	public struct Triangle {
		public uint32 Vindex[3];
		public uint32 Attributes;
		public W3D.Vector3 Normal;
		public float Dist;

		public uint32 vertex_index {
			get {
 return Vindex[0];
			}
			set {
 Vindex[0] = value;
			}
		}

		public uint32 vertex_normal_index {
			get {
 return Vindex[1];
			}
			set {
 Vindex[1] = value;
			}
		}

		public uint32 vertex_texcoords_index {
			get {
 return Vindex[2];
			}
			set {
 Vindex[2] = value;
			}
		}
	}

	[CCode(cname = "W3D_SURFACE_TYPES", cprefix = "SURFACE_TYPE_")]
	public enum SurfaceType {
		LIGHT_METAL,
		HEAVY_METAL,
		WATER,
		SAND,
		DIRT,
		MUD,
		GRASS,
		WOOD,
		CONCRETE,
		FLESH,
		ROCK,
		SNOW,
		ICE,
		DEFAULT,
		GLASS,
		CLOTH,
		TIBERIUM_FIELD,
		FOLIAGE_PERMEABLE,
		GLASS_PERMEABLE,
		ICE_PERMEABLE,
		CLOTH_PERMEABLE,
		ELECTRICAL,
		FLAMMABLE,
		STEAM,
		ELECTRICAL_PERMEABLE,
		FLAMMABLE_PERMEABLE,
		STEAM_PERMEABLE,
		WATER_PERMEABLE,
		TIBERIUM_WATER,
		TIBERIUM_WATER_PERMEABLE,
		UNDERWATER_DIRT,
		UNDERWATER_TIBERIUM_DIRT,
		MAX
	}

	[Flags, CCode(cprefix = "W3D_MESH_FLAG_")]
	public enum MeshFlags {
		NONE,
		COLLISION_BOX,
		SKIN,
		SHADOW,
		ALIGNED,
		COLLISION_TYPE_MASK,
		COLLISION_TYPE_SHIFT,
		COLLISION_TYPE_PHYSICAL,
		COLLISION_TYPE_PROJECTILE,
		COLLISION_TYPE_VIS,
		COLLISION_TYPE_CAMERA,
		COLLISION_TYPE_VEHICLE,
		HIDDEN,
		TWO_SIDED,
		OBSOLETE_LIGHTMAPPED,
		CAST_SHADOW,
		GEOMETRY_TYPE_MASK,
		GEOMETRY_TYPE_NORMAL,
		GEOMETRY_TYPE_CAMERA_ALIGNED,
		GEOMETRY_TYPE_SKIN,
		OBSOLETE_GEOMETRY_TYPE_SHADOW,
		GEOMETRY_TYPE_AABOX,
		GEOMETRY_TYPE_OBBOX,
		GEOMETRY_TYPE_CAMERA_ORIENTED,
		PRELIT_MASK,
		PRELIT_UNLIT,
		PRELIT_VERTEX,
		PRELIT_LIGHTMAP_MULTI_PASS,
		PRELIT_LIGHTMAP_MULTI_TEXTURE,
		SHATTERABLE,
		NPATCHABLE
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.Mesh {
	[Flags, CCode(cprefix = "W3D_VERTEX_CHANNEL_")]
	public enum VertexChannel {
		LOCATION,
		NORMAL,
		TEXCOORD,
		COLOR,
		BONEID
	}

	[Flags, CCode(cprefix = "W3D_FACE_CHANNEL_")]
	public enum FaceChannel {
		FACE
	}

	[CCode(cprefix = "SORT_LEVEL_")]
	public enum SortLevel {
		NONE,
		BIN1,
		BIN2,
		BIN3,
		[CCode(cname = "MAX_SORT_LEVEL")]
		MAX
	}

	[CCode(cname = "W3dMeshHeader3Struct")]
	public struct MeshHeader3 {
		public uint32 Version;
		public uint32 Attributes;
		public char MeshName[W3D.NAME_LEN];
		public char ContainerName[W3D.NAME_LEN];
		public uint32 NumTris; // number of triangles
		public uint32 NumVertices;		// number of unique vertices
		public uint32 NumMaterials;		// number of unique materials
		public uint32 NumDamageStages;	// number of damage offset chunks
		public int32 SortLevel;			// static sorting level of this mesh
		public uint32 PrelitVersion;		// mesh generated by this version of Lightmap Tool
		public uint32 FutureCounts[1];	// future counts

		public uint32 VertexChannels;	// bits for presence of types of per-vertex info
		public uint32 FaceChannels;		// bits for presence of types of per-face info
		public W3D.Vector3 Min;
		public W3D.Vector3 Max;
		public W3D.Vector3 SphCenter;
		public float SphRadius;
	}

	[CCode(cname = "W3dVertInfStruct")]
	public struct VertexInfluence {
		public uint16 BoneIdx;
	}

	[CCode(cname = "W3dMeshDeform")]
	public struct MeshDeform {
		public uint32 SetCount;
		public uint32 AlphaPasses;
		public uint32 reserved[3];
	}

	[CCode(cname = "W3dDeformSetInfo")]
	public struct DeformSetInfo {
		public uint32 KeyframeCount;
		public uint32 flags;
		public uint32 reserved[1];
	}

	[Flags, CCode(cprefix = "W3D_DEFORM_SET_")]
	public enum DeformSetFlags {
		MANUAL_DEFORM
	}

	[CCode(cname = "W3dDeformKeyframeInfo")]
	public struct KeyFrameInfo {
		public uint32 DeformPercent;
		public uint32 DataCount;
		public uint32 reserved[2];
	}

	[CCode(cname = "W3dDeformData")]
	public struct DeformData {
		public uint32 VertexIndex;
		public W3D.Vector3 Position;
		public W3D.Chunk.RGBAColor Color;
		public uint32 reserved[2];
	}

	//Axis-Aligned-Bounding-Box tree
	[CCode(cname = "W3dMeshAABTreeHeader")]
	public struct AABTreeHeader {
		public uint32 NodeCount;
		public uint32 PolyCount;
	}

	[CCode(cname = "W3dMeshAABTreeNode")]
	public struct AABTreeNode {
		public W3D.Vector3 Min;
		public W3D.Vector3 Max;
		public uint32 FrontOrPoly0;
		public uint32 BackOrPolyCount;
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.HTree {
	[CCode(cname = "W3dHierarchyStruct")]
	public struct Hierarchy {
		public uint32 Version;
		public char Name[W3D.NAME_LEN];
		public uint32 NumPivots;
		public W3D.Vector3 Center;
	}

	[CCode(cname = "W3dPivotStruct")]
	public struct Pivot {
		public char Name[W3D.NAME_LEN];
		public uint32 ParentIdx;
		public W3D.Vector3 Translation;
		public W3D.Vector3 EulerAngles;
		public W3D.Vector4 Rotation;
	}

	[CCode(cname = "W3dPivotFixupStruct")]
	public struct PivotFixup {
		public float[,] TM; //4x3 multi dimensional
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.HAnim {
	[CCode(cname = "W3dAnimHeaderStruct")]
	public struct AnimHeader {
		public uint32 Version;
		public char Name[W3D.NAME_LEN];
		public char HierarchyName[W3D.NAME_LEN];
		public uint32 NumFrames;
		public uint32 FrameRate;
	}

	[CCode(cname = "W3dCompressedAnimHeaderStruct")]
	public struct CompressedAnimHeader {
		public uint32 Version;
		public char Name[W3D.NAME_LEN];
		public char HierarchyName[W3D.NAME_LEN];
		public uint32 NumFrames;
		public uint16 FrameRate;
		public uint16 Flavour;
	}

	[CCode(cprefix = "ANIM_CHANNEL_")]
	public enum AnimChannelType {
		X,
		Y,
		Z,
		XR,
		YR,
		ZR,
		Q,

		TIMECODED_X,
		TIMECODED_Y,
		TIMECODED_Z,
		TIMECODED_Q,

		ADAPTIVEDELTA_X,
		ADAPTIVEDELTA_Y,
		ADAPTIVEDELTA_Z,
		ADAPTIVEDELTA_Q,
	}

	[CCode(cprefix = "ANIM_FLAVOUR_")]
	public enum AnimFlavour {
		TIMECODED,
		ADAPTIVE_DELTA,
		VALID
	}

	[CCode(cname = "W3dAnimChannelStruct")]
	public struct AnimChannel {
		public uint16 FirstFrame;
		public uint16 LastFrame;
		public uint16 VectorLen;
		public uint16 Flags;
		public uint16 Pivot;
	}

	[CCode(cprefix = "BIT_CHANNEL_")]
	public enum BitChannelType {
		VIS,
		TIMECODED_VIS
	}

	[CCode(cname = "W3dBitChannelStruct")]
	public struct BitChannel {
		public uint16 FirstFrame;
		public uint16 LastFrame;
		public uint16 FlagS;
		public uint16 Pivot;
		public uint8 DefaultVal;
	}

	[Flags, CCode(cprefix = "W3D_TIMECODED_")]
	public enum TimeCodedFlags {
		[CCode(cname = "W3D_TIMECODED_BINARY_MOVEMENT_FLAG")]
		BINARY_MOVEMENT,
		BIT_MASK
	}

	[CCode(cname = "W3dTimeCodedAnimChannelStruct")]
	public struct TimeCodedAnimChannel {
		public uint32 NumTimeCodes;
		public uint16 Pivot;
		public uint8 VectorLen;
		public uint8 Flags;
		public uint32 Data[1];
	}

	[CCode(cname = "W3dTimeCodedBitChannelStruct")]
	public struct TimeCodedBitChannel {
		public uint32 NumTimeCodes;
		public uint16 Pivot;
		public uint8 VectorLen;
		public uint8 Flags;
		public uint32 Data[1];
	}

	[CCode(cname = "W3dAdaptiveDeltaAnimChannelStruct")]
	public struct AdaptiveDeltaAnimChannel {
		public uint32 NumTimeCodes;
		public uint16 Pivot;
		public uint8 VectorLen;
		public uint8 Flags;
		public float Scale;
		public uint32 Data[1];
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.HMorphAnim {
	[CCode(cname = "W3dMorphAnimHeaderStruct")]
	public struct MorphAnimHeader {
		public uint32 Version;
		public char Name[W3D.NAME_LEN];
		public char HierarchyName[W3D.NAME_LEN];
		public uint32 FrameCount;
		public float FrameRate;
		public uint32 ChannelCount;
	}

	[CCode(cname = "W3dMorphAnimKeyStruct")]
	public struct MorphAnimKey {
		public uint32 MorphFrame;
		public uint32 PoseFrame;
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.HModel {
	[CCode(cname = "W3dHModelHeaderStruct")]
	public struct ModelHeader {
		public uint32 Version;
		public char Name[W3D.NAME_LEN];
		public char HierarchyName[W3D.NAME_LEN];
		public uint16 NumConnections;
	}

	[CCode(cname = "W3dHModelNodeStruct")]
	public struct ModelNode {
		public char Name[W3D.NAME_LEN];
		public uint16 PivotIdX;
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.Lights {
	[Flags, CCode(cprefix = "W3D_LIGHT_ATTRIBUTE_")]
	public enum LightAttributes {
		TYPE_MASK,
		POINT,
		DIRECTIONAL,
		SPOT,
		CAST_SHADOWS
	}

	[CCode(cname = "W3dLightStruct")]
	public struct Light {
		public uint32 Attributes;
		public uint32 Unused;
		public W3D.Chunk.RGBColor Ambient;
		public W3D.Chunk.RGBColor Diffuse;
		public W3D.Chunk.RGBColor Specular;
		public float Intensity;
	}

	[CCode(cname = "W3dSpotLightStruct")]
	public struct SpotLight {
		public W3D.Vector3 SpotDirection;
		public float SpotAngle;
		public float SpotExponent;
	}

	[CCode(cname = "W3dLightAttenuationStruct")]
	public struct LightAttenuation {
		public float Start;
		public float End;
	}

	[CCode(cname = "W3dLightTransformStruct")]
	public struct LightTransform {
		float[,] Transform; //3x4 multi dimensional
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.ParticleEmitters {
	[CCode(cprefix = "EMITTER_TYPEID_")]
	public enum EmitterTypeId {
		DEFAULT,
		COUNT
	}

	[CCode(cname = "W3dEmitterHeaderStruct")]
	public struct EmitterHeader {
		public uint32 Version;
		public char Name[W3D.NAME_LEN];
	}

	[CCode(cname = "W3dEmitterUserInfoStruct")]
	public struct EmitterUserInfo {
		public uint32 Type;
		public uint32 SizeofStringParam;
		[CCode(array_length_cname = "SizeofStringParam")]
		public char[] StringParam;
	}

	[CCode(cname = "W3dEmitterInfoStruct")]
	public struct EmitterInfo {
		public char TextureFilename[260];
		public float StartSize;
		public float EndSize;
		public float Lifetime;
		public float EmissionRate;
		public float MaxEmissions;
		public float VelocityRandom;
		public float PositionRandom;
		public float FadeTime;
		public float Gravity;
		public float Elasticity;
		public W3D.Vector3 Velocity;
		public W3D.Vector3 Acceleration;
		public W3D.Chunk.RGBAColor StartColor;
		public W3D.Chunk.RGBAColor EndColor;
	}

	[CCode(cname = "W3dVolumeRandomizerStruct")]
	public struct VolumeRandomizer {
		public uint32 ClassID;
		public float Value1;
		public float Value2;
		public float Value3;
		public uint32 reserved[4];
	}

	[Flags, CCode(cprefix = "W3D_EMITTER_RENDER_MODE_")]
	public enum EmitterRenderMode {
		TRI_PARTICLES,
		QUAD_PARTICLES,
		LINE,
		LINEGRP_TETRA,
		LINEGRP_PRISM
	}

	[Flags, CCode(cprefix = "W3D_EMITTER_FRAME_MODE_")]
	public enum EmitterFrameMode {
		1x1,
		2x2,
		4x4,
		8x8,
		16x16
	}

	[CCode(cname = "W3dEmitterInfoStructV2")]
	public struct EmitterInfoStruct2 {
		public uint32 BurstSize;
		public VolumeRandomizer CreationVolume;
		public VolumeRandomizer VelRandom;
		public float OutwardVel;
		public float VelInherit;
		public W3D.Chunk.Shader Shader;
		public uint32 RenderMode;
		public uint32 FrameMode;
		public uint32 reserved[6];
	}

	[CCode(cname = "W3dEmitterPropertyStruct")]
	public struct EmitterProperty {
		public uint32 ColorKeyframes;
		public uint32 OpacityKeyframes;
		public uint32 SizeKeyframes;
		public W3D.Chunk.RGBAColor ColorRandom;
		public float OpacityRandom;
		public float SizeRandom;
		public uint32 reserved[4];
	}

	[Ccode(cname = "W3dEmitterColorKeyframeStruct")]
	public struct EmitterColorKeyFrame {
		public float Time;
		public W3D.Chunk.RGBAColor Color;
	}

	[CCode(cname = "W3dEmitterOpacityKeyframeStruct")]
	public struct EmitterOpacityKeyFrame {
		public float Time;
		public float Opacity;
	}

	[CCode(cname = "W3dEmitterSizeKeyframeStruct")]
	public struct EmitterSizeKeyFrame {
		public float Time;
		public float Size;
	}

	[CCode(cname = "W3dEmitterRotationHeaderStruct")]
	public struct EmitterRotationHeader {
		public uint32 KeyframeCount;
		public float Random;
		public float OrientationRandom;
		public uint32 Reserved[1];
	}

	[CCode(cname = "W3dEmitterRotationKeyframeStruct")]
	public struct EmitterRotationKeyFrame {
		public float Time;
		public float Rotation;
	}

	[CCode(cname = "W3dEmitterFrameHeaderStruct")]
	public struct EmitterFrameHeader {
		public uint32 KeyframeCount;
		public float Random;
		public uint32 Reserved[2];
	}

	[CCode(cname = "W3dEmitterFrameKeyframeStruct")]
	public struct EmitterFrameKeyFrame {
		public float Time;
		public float Frame;
	}

	[CCode(cname = "W3dEmitterBlurTimeHeaderStruct")]
	public struct EmitterBlurTimeHeader {
		public uint32 KeyframeCount;
		public float Random;
		public uint32 Reserved[1];
	}

	[CCode(cname = "W3dEmitterBlurTimeKeyframeStruct")]
	public struct EmitterBlurTimeKeyFrame {
		public float Time;
		public float BlurTime;
	}

	[Flags, CCode(cprefix = "W3D_ELINE_")]
	public enum EmitterLine {
		MERGE_INTERSECTIONS,
		FREEZE_RANDOM,
		DISABLE_SORTING,
		END_CAPS,
		TEXTURE_MAP_MODE_MASK,
		TEXTURE_MAP_MODE_OFFSET,
		UNIFORM_WIDTH_TEXTURE_MAP,
		UNIFORM_LENGTH_TEXTURE_MAP,
		TILED_TEXTURE_MAP,
		DEFAULT_BITS
	}

	[CCode(cname = "W3dEmitterLinePropertiesStruct")]
	public struct EmitterLineProperties {
		public uint32 Flags;
		public uint32 SubdivisionLevel;
		public float NoiseAmplitude;
		public float MergeAbortFactor;
		public float TextureTileFactor;
		public float UPerSec;
		public float VPerSec;
		public uint32 Reserved[9];
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.Aggregate {
	[CCode(cname = "W3dAggregateHeaderStruct")]
	public struct AggregateHeader {
		public uint32 Version;
		public char Name[W3D.NAME_LEN];
	}

	[CCode(cname = "W3dAggregateInfoStruct")]
	public struct AggregateInfo {
		public char BaseModelName[W3D.MESH_PATH_ENTRY_LEN];
		public uint32 SubobjectCount;
	}

	[CCode(cname = "W3dAggregateSubobjectStruct")]
	public struct AggregateSubobject {
		public char SubobjectName[W3D.MESH_PATH_ENTRY_LEN];
		public char BoneName[W3D.MESH_PATH_ENTRY_LEN];
	}

	[Flags, CCode(cprefix = "W3D_AGGREGATE_")]
	public enum AggregateFlags {
		FORCE_SUB_OBJ_LOD
	}

	[CCode(cname = "W3dAggregateMiscInfo")]
	public struct AggregateMiscInfo {
		public uint32 OriginalClassID;
		public uint32 Flags;
		public uint32 reserved;
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.HLod {
	[CCode(cname = "W3dHLodHeaderStruct")]
	public struct HLodHeaderStruct {
		public uint32 Version;
		public uint32 LodCount;
		public char Name[W3D.NAME_LEN];
		public char HierarchyName[W3D.NAME_LEN];
	}

	[CCode(cname = "W3dHLodArrayHeaderStruct")]
	public struct HLodArrayHeader {
		public uint32 ModelCount;
		public float MaxScreenSize;
	}

	[CCode(cname = "W3dHLodSubObjectStruct")]
	public struct HLodSubObject {
		public uint32 BoneIndex;
		public char Name[W3D.MESH_PATH_ENTRY_LEN];
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.Box {
	[Flags, CCode(cprefix = "W3D_BOX_ATTRIBUTE_")]
	public enum BoxAttribute {
		ORIENTED,
		ALIGNED,
		COLLISION_TYPE_MASK,
		COLLISION_TYPE_SHIFT,
		COLLISION_TYPE_PHYSICAL,
		COLLISION_TYPE_PROJECTILE,
		COLLISION_TYPE_VIS,
		COLLISION_TYPE_CAMERA,
		COLLISION_TYPE_VEHICLE
	}

	[CCode(cname = "W3dBoxStruct")]
	public struct Box {
		public uint32 Version;
		public uint32 Attribute;
		public char Name[W3D.MESH_PATH_ENTRY_LEN];
		public W3D.Chunk.RGBColor Color;
		public W3D.Vector3 Center;
		public W3D.Vector3 Extent;
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.NullObject {
	[CCode(cname = "W3dNullObjectStruct")]
	public struct NullObject {
		public uint32 Version;
		public uint32 Attributes;
		public char Name[W3D.MESH_PATH_ENTRY_LEN];
	}
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.DazzleObject {
}

[CCode(cprefix = "", cheader_filename = "w3d_file.h")]
namespace W3D.SoundRenderObject {
	[CCode(cname = "W3dSoundRObjHeaderStruct")]
	public struct SoundRenderObjectHeader {
		public uint32 Version;
		public char Name[W3D.NAME_LEN];
		public uint32 Flags;
	}
}

}