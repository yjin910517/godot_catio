extends Control

# For testing purpose, back room don't create cats
var CatScene = preload("res://Scenes/Cat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	create_cat("cat_003_idel", Vector2(240, 75))
	create_cat("cat_001_rest", Vector2(550, 50))


# Add new cats to scene
func create_cat(animation, pos):
	var cat = CatScene.instantiate()
	cat.position = pos
	# scale down to show prospective
	cat.get_node("CatAnimation").scale *= 0.75
	add_child(cat)
	cat.get_node("CatAnimation").play(animation)
