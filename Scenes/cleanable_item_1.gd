extends Area2D


@onready var dirt_sprite: Sprite2D = $Dirt
@onready var viewport: SubViewport = $SplatmapViewport

#preload white brush:
var brush_texture = preload("res://Assets/Cleanable/white_circle.png")

#progress management:
var dirt_image: Image
var total_dirty_pixels: int = 0
var is_fully_cleaned: bool = false #flag this when finish cleaning

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport.size = Vector2i(dirt_sprite.texture.get_size())
	#Take the changable texture from Subviewport:
	var viewport_tex = viewport.get_texture()
	# Transfer this texture into ShaderMaterials of DirtSprite:
	var mask = dirt_sprite.material as ShaderMaterial
	if mask:
		mask.set_shader_parameter("splatmap_texture", viewport_tex)

	#Get the original image and count the dirty pixels
	dirt_image = dirt_sprite.texture.get_image()
	var width = dirt_image.get_width()
	var height = dirt_image.get_height()
	
	for x in range(width):
		for y in range(height):
			#count color pixels, ignore the transparency:
			if dirt_image.get_pixel(x,y).a >0.1:
				total_dirty_pixels +=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func clean_at_global_position(global_wash_pos: Vector2) -> void:
	print("Đang xịt trúng vật phẩm! ", global_wash_pos)
	if is_fully_cleaned or not dirt_sprite.texture:
		return
	#global_position is tranfered -> Dirtsprite internal position:
	var local_pos = dirt_sprite.to_local(global_wash_pos)
	#Change internal Dirtsprite possition into position inside subViewport
	var texture_size = dirt_sprite.texture.get_size()
	var viewport_pos: Vector2
	if dirt_sprite.centered:
		viewport_pos = local_pos + (texture_size / 2.0)
	else:
		viewport_pos = local_pos
	print("Tọa độ cọ vẽ: ", viewport_pos, " | Kích thước Viewport: ", viewport.size)
	#create a white brush inside SubViewport
	var brush = Sprite2D.new()
	brush.texture = brush_texture
	brush.position = viewport_pos
	brush.scale = Vector2(0.05, 0.05)
	viewport.add_child(brush)
	#wait the frame finish
	await get_tree().process_frame
	await get_tree().process_frame
	#then erase the brush after it clean the frame done
	brush.queue_free()
	
#this func is used when click done
func get_cleaned_percentage():
	if total_dirty_pixels == 0:
		return 100.0
		
	var mask_image: Image = viewport.get_texture().get_image()
	var cleaned_pixels: int = 0
	
	var width = mask_image.get_width()
	var height = mask_image.get_height()
	
	for x in range(width):
		for y in range(height):
			var is_dirt = dirt_image.get_pixel(x,y).a > 0.1
			var is_cleaned = mask_image.get_pixel(x,y).r >0.5
			
			#image pixel must be dirty and get sprayed to be cleaned
			if is_dirt and is_cleaned:
				cleaned_pixels += 1
	return (float(cleaned_pixels)/float(total_dirty_pixels))*100.0
		
#clear the Dirtsprite totally to save the resource
func finish_cleaning() -> void:
	is_fully_cleaned = true
	if is_instance_valid(dirt_sprite): #clear dirtsprite
		dirt_sprite.queue_free()
	#Free the SubViewport 
	if is_instance_valid(viewport):
		viewport.queue_free()
	
