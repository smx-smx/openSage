#version 330
layout (location=0)in vec3 in_pos;
layout (location=1)in vec3 in_normal;
layout (location=2)in vec2 in_txcoord;

uniform mat4 mvp;

out vec4 out_normal;
out vec2 out_txcoord;

void main()
{
	vec4 localPos = vec4(in_pos, 1.0f);

	out_normal = vec4(in_normal,0);
	out_txcoord = in_txcoord;
	gl_Position = mvp * localPos;
}