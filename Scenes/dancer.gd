extends Area2D

func _ready():
	var toy_motion = "dancing"
	$AnimatedSprite2D.play(toy_motion)
