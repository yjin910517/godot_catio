extends Area2D

func _ready():
	var toy_motion = "tail"
	$AnimatedSprite2D.play(toy_motion)
