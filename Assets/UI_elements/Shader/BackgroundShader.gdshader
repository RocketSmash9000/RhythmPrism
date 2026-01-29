shader_type canvas_item;

uniform float brightness : hint_range(0.0, 1.0) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
    // Mix the original color with white based on brightness value.
    COLOR = mix(tex_color, vec4(1.0), brightness);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
