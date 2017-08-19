#version 330
in vec4 out_normal;
in vec2 out_txcoord;

uniform sampler2D diffuse;

out vec4 color;

void main()
{
	vec2 uv = vec2(out_txcoord.x, out_txcoord.y);
	color = texture(diffuse, uv);
}