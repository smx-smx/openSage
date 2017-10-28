#version 330
in vec4 out_normal;
in vec2 out_txcoord;

uniform sampler2D texture;

out vec4 color;


uniform bool has_texture;
uniform float t;

void main()
{
	vec2 uv = vec2(out_txcoord.x, out_txcoord.y);

	if(has_texture)
		color = texture(texture, uv);
	else
		//trasparent black
		color = vec4(0.0, 0.0, 0.0, 0.0);
}