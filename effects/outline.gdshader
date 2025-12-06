shader_type canvas_item;

uniform bool show = false;
uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 4) = 1.0;

varying vec4 modulate;

void vertex() {
	// Preserve modulated color of sprite for outline
	modulate = COLOR;
}


void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if (show)
	{
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;

		// Add outline color to all sides of sprite
		float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		outline = min(outline, 1.0);

		// Add together sprite and outline
		vec4 color = texture(TEXTURE, UV);
		tex = mix(color, line_color, outline - color.a);
	}
	
	// Apply modulate color
    COLOR = tex * modulate;
}
