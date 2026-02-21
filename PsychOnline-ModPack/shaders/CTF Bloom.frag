#pragma header

#define iterations 12

uniform float radius;
uniform float exponent;
uniform float coeff;

const vec2 offsets[iterations] = {
	vec2(-0.326212, -0.405805),
	vec2(-0.840144, -0.073580),
	vec2(-0.695914, 0.457137),
	vec2(-0.203345, 0.620716),
	vec2(0.962340, -0.194983),
	vec2(0.473434, -0.480026),
	vec2(0.519456, 0.767022),
	vec2(0.185461, -0.893124),
	vec2(0.507431, 0.064425),
	vec2(0.896420, 0.412458),
	vec2(-0.321940, -0.932615),
	vec2(-0.791559, -0.597705),
};

vec4 highlight(vec4 i) {
	return pow(i, vec4(exponent)) * coeff;
}

vec2 uv = openfl_TextureCoordv;
void main() {
	vec4 s = flixel_texture2D(bitmap, uv);
	if (exponent == 0.) {gl_FragColor = s;} else {
		vec4 o = highlight(s);
		vec2 t = radius / openfl_TextureSize;
		
		for (int i = 0; i < iterations; i++)
			o += highlight(flixel_texture2D(bitmap, uv + t * offsets[i]));
		o /= iterations + 1;
		
		gl_FragColor = s + highlight(o);
	}
}
