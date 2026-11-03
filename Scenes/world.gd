extends Node2D

@onready var cleanable_item = $CleanableItem1
@onready var washing_gun = $WashingGun
@onready var finish_cleaning: Button = $UI/FinishCleaning
@onready var progress_label: Label = $UI/ProgressLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI/Replay.hide()
	#Connect signal when drag mouse cursor in and out
	finish_cleaning.mouse_entered.connect(_on_button_mouse_entered)
	finish_cleaning.mouse_exited.connect(_on_button_mouse_exited)
	#Connect button to check completeness
	finish_cleaning.pressed.connect(_on_finish_button_pressed)
	
func _on_button_mouse_entered() -> void:
	washing_gun.set_wash_mode(false) #show normal cursor

func _on_button_mouse_exited() -> void:
	washing_gun.set_wash_mode(true) #washing gun as cursor
	
func _on_finish_button_pressed() -> void:
	var percent = cleanable_item.get_cleaned_percentage()
	progress_label.text = "cleanliness: %.1f%%" % percent
	if percent >= 95:
		cleanable_item.finish_cleaning()
		progress_label.text = "Great job! (%.1f%%)"% percent
		finish_cleaning.disabled = true
	else:
		cleanable_item.finish_cleaning()
		progress_label.text = "What the hell are you doing!? (%.1f%%)"% percent
		finish_cleaning.disabled = true
	$UI/Replay.show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_replay_pressed() -> void:
	$UI/Replay.hide()
	get_tree().reload_current_scene()
	
