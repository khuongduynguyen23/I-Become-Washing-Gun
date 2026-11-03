shader_type canvas_item;

uniform sampler2D splatmap_texture : hint_default_black;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 dirt_color = texture(TEXTURE, UV);
	// Đọc màu đỏ từ splatmap (nơi cọ trắng vẽ lên sẽ có r = 1.0)
	float mask_value = texture(splatmap_texture, UV).r;
	
	// Giữ nguyên màu, nhưng giảm độ trong suốt tại các điểm đã xịt trắng
	dirt_color.a *= (1.0 - mask_value);
	COLOR = dirt_color;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
