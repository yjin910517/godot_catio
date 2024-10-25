extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func start_sky_animations():
	
	$Sun.play("default")
	$CloudPlayer1.play("Cloud movement")
	$CloudPlayer2.play("Cloud movement 2")
