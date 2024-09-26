extends Control

var MAX_LENGTH = 80


# Called when the node enters the scene tree for the first time.
func _ready():
	$LikeBar.size.x = 1
	
	
# Show animated effect of like score change
func run_bar_animation(score_percent):

	var tween = get_tree().create_tween()
	var new_x = score_percent * MAX_LENGTH / 100.0
	tween.tween_property($LikeBar, "size", Vector2(new_x, $LikeBar.size.y), 1)
