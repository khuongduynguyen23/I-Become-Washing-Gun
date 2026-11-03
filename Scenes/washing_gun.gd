extends Area2D


@onready var particles: GPUParticles2D = $WaterParticles
var is_active: bool = true #Gun states active


func _ready() -> void:
	particles.emitting = false
	if is_active:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func set_wash_mode(active: bool):
	is_active = active
	visible = active
	if particles: 
		particles.emitting = false
	
	if true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _physics_process(delta: float) -> void:
	if not is_active:
		return
		
	#the gun is the cursor
	global_position = get_global_mouse_position()
	
	#check left mouse
	var is_spraying = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	particles.emitting = is_spraying
	
	#clean if spraying
	if is_spraying:
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.play()
		spray_water()
	else:
		if $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.stop()
func spray_water():
	#scan the area that touch the hitbox
	var overlapping_areas = get_overlapping_areas()
	print("Số lượng vùng quét trúng: ", overlapping_areas.size())
	
	for area in overlapping_areas:
		#get father of hurtbox
		var item = area.get_parent()
		if item and item.has_method("clean_at_global_position"):
			item.clean_at_global_position(global_position)
