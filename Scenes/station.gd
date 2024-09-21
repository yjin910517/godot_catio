extends Control

var vacancy = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Get current bar length
func get_bar_length():
	return $LikeBar.size.x


# Update bar length
func set_bar_length(length):
	$LikeBar.size.x = length
