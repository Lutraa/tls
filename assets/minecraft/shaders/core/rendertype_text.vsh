#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

bool isAt(int offset, int vID, int pos) {
	return (((vID == 1 || vID == 2) && offset == pos) || ((vID == 0 || vID == 3) && offset == (pos+8)));
}

void main() {
	vec3 pos = Position;

	gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
	
	// Delete sidebar numbers
	if(	gl_Position.z == 0 && gl_Position.x >= 0.93 && gl_Position.y >= -0.35 && vertexColor.g == 84.0/255.0 && vertexColor.b == 84.0/255.0 && vertexColor.r == 252.0/255.0) { 
		gl_Position = ProjMat * ModelViewMat * vec4(ScreenSize + 100.0, 0.0, 0.0); 
	}

	if (Color == vec4(78/255., 92/255., 36/255., Color.a) && Position.z == 0.03) {
        vertexColor = texelFetch(Sampler2, UV2 / 16, 0); // remove color from no shadow marker
    } else if (Color == vec4(19/255., 23/255., 9/255., Color.a) && Position.z == 0) {
        vertexColor = vec4(0); // remove shadow
    }


}

