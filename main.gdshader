shader_type spatial;

uniform float height_scale = 0.15;
uniform sampler2D noise;


void vertex() {
	float height = texture(noise, VERTEX.xz / 2.0 + 0.5).x;
	VERTEX.y += height * height_scale;
}

void fragment() {
	float noiseValue = texture(noise, UV).x + 0.3;


	ALBEDO = vec3(noiseValue);
	ALPHA = noiseValue * 1.8;
	
}

//void light() {

//}
