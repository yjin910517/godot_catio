shader_type canvas_item;

uniform float fade_amount : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // Fetch the original texture color at the current UV coordinates
    vec4 tex_color = texture(TEXTURE, UV);

    // Multiply the alpha component by fade_amount
    tex_color.a *= fade_amount;

    // Set the final color output, modifying the alpha to control transparency
    COLOR = tex_color;
}