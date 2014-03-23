#version 330

in geom_to_frag {
	vec4 color;
} g2f;

layout(location = 0) out vec4 color;

void main(void)
{
    color = g2f.color;
}