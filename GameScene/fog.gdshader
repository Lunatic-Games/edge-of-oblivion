shader_type canvas_item;

uniform float border_width = 20.0f;

void fragment() {
	vec2 texture_size = 1.0f / TEXTURE_PIXEL_SIZE;
	vec2 pos = texture_size * UV;
	
	COLOR.a = 0.0;
	
	if (pos.x <= border_width) {
		COLOR.a += 1.0f - pos.x / border_width;
	}
	if ((texture_size.x - pos.x) <= border_width) {
		COLOR.a += 1.0f - (texture_size.x - pos.x) / border_width;
	}
	if (pos.y <= border_width) {
		COLOR.a += 1.0f - pos.y / border_width;
	}
	if ((texture_size.y - pos.y) <= border_width) {
		COLOR.a += 1.0f - (texture_size.y - pos.y) / border_width;
	}
}
