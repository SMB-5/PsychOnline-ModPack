#pragma header
//SHADER PORTED BY RALT THANK YOU SO MUCH
#define HPI 1.57079632679
#define PI 3.1415926538
#define PI2 6.28318530718
vec2 uv = openfl_TextureCoordv;
vec2 res = openfl_TextureSize; // CHANGE THIS TO vec2(1280., 720.) IF YOU WANT TO USE THIS IN CAMERA

// Properties
#define iterations 12.0 // og 12.0, mq 10.0, lq 8.0
uniform float radius; // = 5.0
uniform float exponent; // = 2.0
uniform float coeff; // = 1.5

float ralsin(float v) { // sin
	v /= PI;
	v = 2. * fract(v / 2.);
	return v <= 1. ? -4. * v * (v - 1.) : 4. * (v - 1.) * (v - 2.);
}

float raltys(float v) { // cos
	return ralsin(HPI + v);
}

vec4 highlight(vec4 i) {
	return pow(i, vec4(exponent)) * coeff;
}

void main() {
	vec2 size = radius/res;

	vec4 s = flixel_texture2D(bitmap, uv);
	vec4 o = highlight(s);

	float a = 0.;
	for(float i = 0.; i < iterations; i++) {
		o += highlight(flixel_texture2D(bitmap, 
			uv + size * vec2(ralsin(a), raltys(a))
		));
		a += PI2 / iterations;
	}

	gl_FragColor = s + highlight(o / vec4(iterations + 1.));
}