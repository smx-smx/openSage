[CCode(cprefix = "glm_", cheader_filename = "cglm/cglm.h")]
namespace CGlm {
	public int sign(int val);
	public float rad(float deg);
	public float deg(float rad);
	public void make_rad(float *deg);
	public void make_deg(float *rad);
	public float pow2(float x);
	
	[CCode(cname = "int", cprefix = "glm_ivec3")]
	public struct IntVector3 {
		public void print(Posix.FILE ostream);
	}
	
	[CCode(cname = "float", cprefix = "glm_vec_")]
	public struct Vector3 {
		public void copy(Vector3 dest);
		public float dot(Vector3 b);
		public void cross(Vector3 b, Vector3 d);
		public float norm2(Vector3 v);
		public float norm();
		public void add(Vector3 v2, Vector3 dest);
		public void sub(Vector3 v2, Vector3 dest);
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
		
		[CCode(cname = "glm_vec3_print")]
		public void print(Posix.FILE ostream);
	}
	
	[CCode(cname = "float", cprefix = "glm_vec4_")]
	public struct Vector4 {
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
	}
	
	[CCode(cname = "float *", cprefix = "glm_mat3_")]
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
	
	[CCode(cname = "float *", cprefix = "glm_vec4_")]
	public struct Matrix4 {
		public void ucopy(Matrix4 dest);
		public void copy(Matrix4 dest);
		public void identity();
		public void pick3(Matrix3 dest);
		public void pick3t(Matrix3 dest);
		[CCode(instance_pos = 1.9)]
		public void ins3(Matrix3 mat);
		public void mul(Matrix4 m2, Matrix4 dest);

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
	}
	
	[CCode(cname = "float", cprefix = "glm_quat_")]
	public struct Quaternion {
		public void identity();
		
		[CCode(cname = "glm_quat")]
		public void init(float angle, float x, float y, float z);
		
		[CCode(cname = "glm_quatv")]
		public void init_vec3(float angle, Vector3 vec);
		
		public float norm();
		public void normalize();
		public float dot(Quaternion r);
		public void mulv(Quaternion q2, Quaternion dest);
		public void Matrix4(Matrix4 dest);
		public void slerp(Quaternion r, float t, Quaternion dest);
		
		[CCode(cname = "glm_versor_print")]
		public void print(Posix.FILE ostream);
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
	
	[CCode(cname = "float", cprefix = "glm_euler_")]
	public struct EulerAngles {
		[CCode(instance_pos = 1.9)]
		public void angles(Matrix4 m);
		
		[CCode(cname = "glm_euler")]
		public void euler(Matrix4 dest);
		
		public void zyx(Matrix4 dest);
		public void zxy(Matrix4 dest);
		public void xzy(Matrix4 dest);
		public void yzx(Matrix4 dest);
		public void yxz(Matrix4 dest);
		public void by_order(Order axis, Matrix4 dest);
	}
}

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
	public void perspective_default(float aspect, CGlm.Matrix4 dest);
	public void perspective_resize(float aspect, CGlm.Matrix4 proj);
	public void lookat(
		CGlm.Vector3 eye,
		CGlm.Vector3 center,
		CGlm.Vector3 up,
		CGlm.Matrix4 dest);
}