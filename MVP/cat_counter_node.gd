extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# update score display
func set_score(score):
	$CatCounter.text = str(score)
	

# return center pos for scoring vfx destination
func get_center():
	
	var center_pos = position + $UIBackground.size / 2
	return center_pos
