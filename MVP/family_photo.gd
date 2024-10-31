extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$John.play("cat_004_idle")
	$Bob.play("cat_003_idle")
	$Tyler.play("cat_002_idle")
	$Jessie.play("cat_001_idle")


func show_final_scene(score):
	$CatCounter.text = str(score)
	show()
