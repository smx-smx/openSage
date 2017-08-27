//[CCode(cprefix = "glm_", cheader_filename = "cglm/cglm.h")]
[CCode(cprefix = "glm_", lower_case_cprefix = "glm_", cheader_filename = "cglm_wrap.h")]
namespace CGlm {
	public int sign(int val);
	public float rad(float deg);
	public float deg(float rad);
	public void make_rad(float *deg);
	public void make_deg(float *rad);
	public float pow2(float x);
	
	[SimpleType, CCode(cname = "ivec3", cprefix = "glm_ivec3_")]
	public struct IntVector3 {
		public IntVector3(){}
		
		public void print(Posix.FILE ostream);
	}
	
	[SimpleType, CCode(
		cname = "vec3",
		cprefix = "glm_vec_",
		copy_function = "glm_vec_copy"
	)]
	public struct Vector3 {
		public Vector3(){}

		public float x {
			get {
				return ((float *)this)[0];
			}
			set {
				((float *)this)[0] = value;
			}
		}

		public float y {
			get {
				return ((float *)this)[1];
			}
			set {
				((float *)this)[1] = value;
			}
		}

		public float z {
			get {
				return ((float *)this)[2];
			}
			set {
				((float *)this)[2] = value;
			}
		}
	
		public void copy(Vector3 dest);
		public float dot(Vector3 b);
		[CCode(cname = "glm_vec_cross")]
		private static void _cross(Vector3 a, Vector3 b, Vector3 d);

		[CCode(cname = "vala_glm_vec_cross")]
		public void cross(Vector3 b){
			_cross(b, this, this);
		}

		public float norm2(Vector3 v);
		public float norm();
		public void add(Vector3 v2, Vector3 dest);
		[CCode(cname = "glm_vec_sub")]
		private static void _sub(Vector3 v1, Vector3 v2, Vector3 dest);

		[CCode(cname = "vala_glm_vec_sub")]
		public void sub(Vector3 v2){
			_sub(this, v2, this);
		}

		public void scale(float s, Vector3 dest);
		public void scale_as(float s, Vector3 dest);
		public void flipsign();
		public void normalize();
		public void normalize_to(Vector3 dest);
		public float distance(Vector3 v2);
		public float angle(Vector3 v2);
		public void rotate(float angle, Vector3 axis);
		[CCode(instance_pos = 1.9)]
		public void rotate_m4(Matrix4 m, Vector3 dest);
		public void proj(Vector3 b, Vector3 dest);
		public void center(Vector3 v2, Vector3 dest);
		
		public Order get_order(){
			float *orderVec = (float *)&this;
			return (Order)(
				(int)orderVec[0] |
				(int)orderVec[1] << 2 |
				(int)orderVec[2] << 4
			);
		}
		
		[CCode(cname = "glm_euler_angles", instance_pos = 1.9)]
		public void angles(Matrix4 m);
		
		[CCode(cname = "glm_euler")]
		public void euler(Matrix4 dest);
		
		[CCode(cname = "glm_euler_zyx")]
		public void zyx(Matrix4 dest);
		[CCode(cname = "glm_euler_zxy")]
		public void zxy(Matrix4 dest);
		[CCode(cname = "glm_euler_xzy")]
		public void xzy(Matrix4 dest);
		[CCode(cname = "glm_euler_yzx")]
		public void yzx(Matrix4 dest);
		[CCode(cname = "glm_euler_yxz")]
		public void yxz(Matrix4 dest);
		[CCode(cname = "glm_euler_by_order")]
		public void by_order(Order axis, Matrix4 dest);
		
		/*public static Vector3 from_data(float x, float y, float z){
			float *data = new float[3];
			data[0] = x;
			data[1] = y;
			data[2] = z;
			return (Vector3)data;
		}*/

		public void import(float x, float y, float z);

		public void _import(float x, float y, float z){
			float *v = (float *)this;
			v[0] = x;
			v[1] = y;
			v[3] = z;
		}
		
		[CCode(cname = "glm_vec3_print")]
		public void print(Posix.FILE ostream);
	}
	
	[SimpleType, CCode(cname = "vec4", cprefix = "glm_vec4_")]
	public struct Vector4 {
		public Vector4(){}
	
		public void copy3(Vector3 dest);
		public void copy(Vector4 dest);
		public float dot(Vector4 b);
		public float norm2();
		public float norm();
		public void add(Vector4 v2, Vector4 dest);
		public void sub(Vector4 v2, Vector4 dest);
		public void scale(float s, Vector4 dest);
		public void scale_as(float s, Vector4 dest);
		public void flipsign();
		public void normalize();
		public void normalize_to(Vector4 dest);
		public float distance(Vector4 v2);
		
		// Extensions
		public void mulv(Vector4 b, Vector4 d);
		public void broadcast(float val, Vector4 d);
		public bool eq(float val);
		public bool eq_eps(float val);
		public bool eq_all();
		public bool eqv(Vector4 v2);
		public bool eqv_eps(Vector3 v2);
		public float max();
		public float min();
		
		public void print(Posix.FILE ostream);

		public void import(float w, float x, float y, float z);
	}
	
	[SimpleType, CCode(
		cname = "mat3",
		cprefix = "glm_mat3_",
		default_value = "GLM_MAT3_IDENTITY_INIT",
		copy_function = "glm_mat3_copy"
	)]
	public struct Matrix3 {
		public void copy(Matrix3 dest);
		public void identity();
		public void mul(Matrix3 m2, Matrix3 dest);
		public void transpose_to(Matrix3 dest);
		public void transpose();
		public void mulv(Vector3 v, Vector3 dest);
		public void scale(float s);
		public float det();
		public void inv(Matrix3 dest);
		public void swap_col(int col1, int col2);
		public void swap_row(int row1, int row2);
		
		public void print(Posix.FILE ostream);
	}
	
	[SimpleType, CCode(
		cname = "mat4",
		cprefix = "glm_mat4_",
		default_value = "GLM_MAT4_IDENTITY_INIT",
		copy_function = "glm_mat4_copy"
	)]
	public struct Matrix4 {
		public Matrix4(){}
	
		public void ucopy(Matrix4 dest);
		public void copy(Matrix4 dest);
		public void identity();
		public void pick3(Matrix3 dest);
		public void pick3t(Matrix3 dest);
		[CCode(instance_pos = 1.9)]
		public void ins3(Matrix3 mat);
		
		[CCode(cname = "glm_mat4_mul")]
		public static void _mul(Matrix4 m1, Matrix4 m2, Matrix4 dest);
		
		[CCode(cname = "vala_glm_mat4_mul")]
		public void mul(Matrix4 m2){
			_mul(this, m2, this);
		}

		public static void mulN(Matrix4 matrices[], Matrix4 dest);
		
		public void mulv(Vector4 v, Vector4 dest);
		public void mulv3(Vector3 v, Vector3 dest);
		public void transpose_to(Matrix4 dest);
		public void transpose();
		public void scale_p(float s);
		public void scale(float s);
		public float det();
		public void inv(Matrix4 dest);
		public void inv_precise(Matrix4 dest);
		public void swap_col(int col1, int col2);
		public void swap_row(int row1, int row2);
		
		public void print(Posix.FILE ostream);

		public void import(float* d);

		// affine
		[CCode(cname = "glm_translate_to")]
		public void translate_to(Vector3 v, Matrix4 dest);
		[CCode(cname = "glm_translate")]
		public void translate(Vector3 v);
		[CCode(cname = "glm_translate_x")]
		public void translate_x(float to);
		[CCode(cname = "glm_translate_y")]
		public void translate_y(float to);
		[CCode(cname = "glm_translate_z")]
		public void translate_z(float to);
		[CCode(cname = "glm_translate_make")]
		public void translate_make(Vector3 v);
		[CCode(cname = "glm_scale_to")]
		public void scale_to(Vector3 v, Matrix4 dest);
		[CCode(cname = "glm_scale_make")]
		public void scale_make(Vector3 v);
		[CCode(cname = "glm_scale")]
		public void scalev(Vector3 v);
		[CCode(cname = "glm_scale1")]
		public void scale1(float s);
		
		[CCode(cname = "glm_rotate_x")]
		public void rotate_x(float rad, Matrix4 dest);
		[CCode(cname = "glm_rotate_y")]
		public void rotate_y(float rad, Matrix4 dest);
		[CCode(cname = "glm_rotate_z")]
		public void rotate_z(float rad, Matrix4 dest);
		
		[CCode(cname = "glm_rotate_ndc_make")]
		public void rotate_ndc_make(float angle, Vector3 axis_ndc);
		[CCode(cname = "glm_rotate_ndc")]
		public void rotate_ndc(float angle, Vector3 axis_ndx);
		
		[CCode(cname = "glm_rotate_make")]
		public void rotate_make(float angle, Vector3 axis);	
		[CCode(cname = "glm_rotate")]
		public void rotate(float angle, Vector3 axis);
		
		[CCode(cname = "glm_decompose_scalev")]
		public void decompose_scalev(Vector3 s);
		[CCode(cname = "glm_uniscaled")]
		public bool uniscaled();
		[CCode(cname = "glm_decompose_rs")]
		public void decompose_rs(Matrix4 r, Vector3 s);
		[CCode(cname = "glm_decompose")]
		public void decompose(Vector4 t, Matrix4 r, Vector3 s);
		
		//affine-mat
		//[CCode(cname = "glm_mul")]
		//public void mul(Matrix4 m2, Matrix4 dest);
		[CCode(cname = "glm_inv_tr")]
		public void inv_tr();
		
	}
	
	[SimpleType, CCode(
		cname = "versor",
		cprefix = "glm_quat_",
		default_value = "GLM_QUAT_IDENTITY_INIT",
		copy_function = "glm_vec4_copy"
	)]
	public struct Quaternion {
		public Quaternion(){}
	
		public void identity();
		
		[CCode(cname = "glm_quat")]
		public void init(float angle, float x, float y, float z);
		
		[CCode(cname = "glm_quatv")]
		public void init_vec3(float angle, Vector3 vec);
		
		public float norm();
		public void normalize();
		public float dot(Quaternion r);
		public void mulv(Quaternion q2, Quaternion dest);
		public void mat4(Matrix4 dest);
		public void slerp(Quaternion r, float t, Quaternion dest);
		
		[CCode(cname = "glm_versor_print")]
		public void print(Posix.FILE ostream);
		
		[CCode(cname = "glm_vec4_import")]
		public void import(float w, float x, float y, float z);
	}
	
	[CCode(cname = "glm_euler_sq", cprefix = "GLM_EULER_")]
	public enum Order {
		XYZ,
		XZY,
		YZX,
		YXZ,
		ZXY,
		ZYX;
		
		[CCode(cname = "glm_euler_order")]
		public static Order from_ints(int newOrder[3]);
	}
	
	[SimpleType, CCode(cname = "vec3", cprefix = "glm_euler_")]
	public struct EulerAngles {
		
	}
}

[CCode(cprefix = "glm_", lower_case_cprefix = "glm_", cheader_filename = "cglm_wrap.h")]
namespace CGlm.Camera {
	public void frustum(
		float left,
		float right,
		float bottom,
		float top,
		float near,
		float far,
		CGlm.Matrix4 dest);
	
	public void ortho(
		float left,
		float right,
		float bottom,
		float top,
		float near,
		float far,
		CGlm.Matrix4 dest);
		
	public void ortho_default(float aspect, CGlm.Matrix4 dest);
	public void ortho_default_s(float aspect, float size, CGlm.Matrix4 dest);
	
	public void perspective(float fovy, float aspect, float nearVal, float farVal, Matrix4 dest);

	public void perspective_default(float aspect, CGlm.Matrix4 dest);
	public void perspective_resize(float aspect, CGlm.Matrix4 proj);
	public void lookat(
		CGlm.Vector3 eye,
		CGlm.Vector3 center,
		CGlm.Vector3 up,
		CGlm.Matrix4 dest);
}