extends Camera2D

signal camera_done()

func _ready():
	pass
	

func sky_to_garden():
	
	var target_position = Vector2(0, 0)  

	# Use a tween to move the camera smoothly
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	
	# Set up tween for camera movement from initial to target position
	tween.tween_property(self, "position", target_position, 4.0)
	tween.tween_callback(Callable(self, "_camera_movement_completed"))


func _camera_movement_completed():
	
	emit_signal("camera_done")
