extends Area2D

func _ready():
	var toy_motion = "blue_free"
	$AnimatedSprite2D.play(toy_motion)
