#version 330

layout (location = 0) in vec4 position;
layout (location = 1) in vec4 color;
uniform mat4 MVP;

out vert_to_geom {
	vec4 color;
} v2g;

void main(void)
{
    v2g.color = color;
	//gl_Position = gl_ModelViewProjectionMatrix * position;
    gl_Position = MVP * position;
}
