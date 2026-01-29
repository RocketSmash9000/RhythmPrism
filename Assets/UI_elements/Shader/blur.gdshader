shader_type canvas_item;

uniform float blur_amount: hint_range(0.0, 10.0) = 2.0;
uniform float sigma: hint_range(0.1, 10.0) = 4.0;

void fragment() {
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 inv_tex = 1.0 / tex_size;

    vec4 sum = vec4(0.0);
    float total_weight = 0.0;

    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            // Convert the integer offsets to floats.
            vec2 offset = vec2(float(x), float(y)) * inv_tex * blur_amount;
            float weight = exp(-float(x * x + y * y) / (2.0 * sigma * sigma));
            sum += texture(TEXTURE, UV + offset) * weight;
            total_weight += weight;
        }
    }

    COLOR = sum / total_weight;
}