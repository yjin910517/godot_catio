extends Camera2D

func _ready():
	
	var initial_position = Vector2(0, -180)
	var target_position = Vector2(0, 0)  
	
	position = initial_position
	
	# Use a tween to move the camera smoothly
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	
	# Set up tween for camera movement from initial to target position
	tween.tween_property(self, "position", target_position, 4.0)
