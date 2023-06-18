shader_type canvas_item;

uniform float strength = 0.25f;
uniform vec4 modulate: source_color = vec4(1.0);
uniform sampler2D noise;

void fragment() {
	vec2 dist = vec2(0.5f) - UV;
	float s = sin(TIME);
	float c = cos(TIME);
	
	mat2 m = mat2(vec2(c, -s), vec2(s, c));
	dist *= m;
	
	vec4 coord = texture(noise, 0.5f + dist);
	coord.x -= .5;
	coord.y -= .5;
	
	vec4 lens_color = texture(TEXTURE, UV + coord.xy * strength);
	lens_color *= modulate;
    COLOR = lens_color;
}