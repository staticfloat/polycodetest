#version 330

layout (lines) in;
layout (line_strip, max_vertices=16) out;

in gl_PerVertex {
    vec4  gl_Position;
    float gl_PointSize;
    float gl_ClipDistance[];
} gl_in[];

in vert_to_geom {
	vec4 color;
} v2g[];


out gl_PerVertex {
    vec4  gl_Position;
    float gl_PointSize;
    float gl_ClipDistance[];
};

out geom_to_frag {
    vec4 color;
} g2f;

void main(void)
{
	for( int i=0; i<gl_in.length(); ++i ) {
		gl_Position = gl_in[i].gl_Position;
        gl_PointSize = gl_in[i].gl_PointSize;
        g2f.color = v2g[i].color;
        
        /*
        gl_ClipDistance =
        for( int j=0; j<gl_in[i].gl_ClipDistance.length(); ++j ) {
            gl_ClipDistance[j] = gl_in[i].gl_ClipDistance[j];
        }
         */
		EmitVertex();
	}
	EndPrimitive();
}
