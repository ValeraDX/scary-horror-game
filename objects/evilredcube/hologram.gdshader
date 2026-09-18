shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_test_disabled;

uniform sampler2D depth_texture : hint_depth_texture;
uniform vec3 primary_color : source_color = vec3(1.0, 0.0, 0.0);
uniform vec3 secondary_color : source_color = vec3(1.0, 0.0, 0.0);
uniform float density = 1.0;
uniform float effect_strength = 2.0;

group_uniforms Wipe;
uniform float wipe_scale : hint_range(0.0, 16.0, 0.01) = 3.0;
uniform float wipe_speed : hint_range(0.0, 8.0, 0.01) = 0.5;
uniform float wipe_blend : hint_range(0.0, 1.0, 0.01) = 0.7;

group_uniforms Signal;
uniform float signal_scale = 40.0;
uniform float signal_speed = 1.0;
uniform float signal_random_scale : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float signal_blend : hint_range(0.0, 1.0, 0.01) = 1.0;

group_uniforms Noise;
uniform sampler2D noise_texture;
uniform float noise_distort_amount : hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float noise_amount : hint_range(0.0, 1.0, 0.01) = 1.0;

group_uniforms Grain;
uniform float grain_amount : hint_range(0.0, 1.0, 0.01) = 0.4;

group_uniforms Displacement;
uniform float displacement_amount : hint_range(0.0, 2.0, 0.01) = 1.0;

group_uniforms Flicker;
uniform float flicker_amount : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float flicker_speed : hint_range(0.0, 30.0, 0.01) = 10.0;

varying vec3 vert;

float overlay(float base, float blend){
	float limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec2 overlay(vec2 base, vec2 blend){
	vec2 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

float sample_wipe(float offset){
	return 1.0 - fract(vert.y * wipe_scale + TIME * wipe_speed + offset); 
}

float random(vec2 uv){
	float value = dot(uv, vec2(127.1,311.7));
	return -1.0 + 2.0 * fract(sin(value) * 43758.5453123);
}

void vertex(){
	vert = VERTEX;
	
	float step_time = floor(TIME * 3.0) / 3.0;
	VERTEX += NORMAL * (random(vert.xz * vert.xy + (step_time))) * 0.05 * displacement_amount;
}

vec3 shift_hue(vec3 color, float shift) {
	vec3 gray = vec3(0.57735);
	vec3 projection = gray * dot(gray, color.rgb);
	vec3 U = color.rgb - projection;
	vec3 V = cross(gray, U);
	vec3 shifted = U * cos(shift * 2.0 * PI) + V * sin(shift * 2.0 * PI) + projection;
	return shifted;
}

void fragment() {
	vec3 clip_pos = vec3(SCREEN_UV * 2.0 - 1.0, texture(depth_texture, SCREEN_UV).r);
	vec4 view_pos = INV_PROJECTION_MATRIX * vec4(clip_pos, 1.0);
	view_pos.xyz /= view_pos.w;
	float view_dist = length(view_pos.xyz);
	
	float dist = length(LIGHT_VERTEX);
	
	vec3 color = primary_color;
	if (!FRONT_FACING) {
		dist = min(dist, view_dist);
	}
	else {
		dist = -dist;
		dist = max(dist, -view_dist);
	}
	
	vec3 blended_color = primary_color;
	
	float flicker_mult1 = cos(TIME * PI * 2.0);
	float flicker = sin(TIME * flicker_speed + flicker_mult1) / 2.0 + 0.5;
	flicker = floor(flicker * 4.0) / 3.0;
	flicker = (1.0 - flicker * flicker_amount);
	
	ALBEDO = (dist * color * density) * flicker * 0.6;
	
	float step_time = round(TIME * 4.0) / 4.0;
	
	float grain = fract(dot(vert.x * 234.1421, vert.z * 123.7312) * 20.0);
	
	float noise_xy = texture(noise_texture, vert.xy + step_time).r;
	float noise_zy = texture(noise_texture, vert.zy + step_time).r;
	
	vec2 checker_pos = overlay(floor(vert.xy * 2.0 + step_time) / 3.0, floor(vert.zy * 2.0 - step_time) / 3.0);
	float checker = 1.0 + (fract(dot(checker_pos, vec2(1.0))) * 2.0 - 1.0) * signal_random_scale;
	
	float noise_xyz = mix(1.0, overlay(noise_xy, noise_zy), noise_amount);
	float stepped_noise = step(noise_xyz, 0.9);
	
	float scan = sample_wipe(stepped_noise*noise_distort_amount); 
	float signal = pow(abs(fract(vert.y * (checker) * signal_scale - (TIME * signal_speed)) * 2.0 - 1.0), 0.5);
	
	float fresnel = clamp(dot(normalize(NORMAL), normalize(VIEW)), 0.0, 1.0);
	
	float highlight = pow(fresnel, 4.0);
	highlight = mix(highlight, highlight / (signal + 0.1), signal_blend);
	highlight *= (1.0 - wipe_blend) + scan * wipe_blend;
	highlight *= (1.0 - grain_amount) + grain * grain_amount;
	highlight *= noise_xyz;
	
	if(FRONT_FACING){
		ALBEDO = mix(ALBEDO, ALBEDO + secondary_color * effect_strength, highlight);
	}
}