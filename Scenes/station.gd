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


# Show bar
func show_like_bar():
	$LikeBar.show()


# Hide bar
func hide_like_bar():
	$LikeBar.hide()
	
	
# Show animated effect of like score change
func run_bar_animation(reaction):
	var tween = get_tree().create_tween()
	var tween_icon = Sprite2D.new()
	tween_icon.position = $LikeIcon.position
	tween_icon.scale = $LikeIcon.scale
	# to do: display different texture based on reaction
	# temporarily hide $LikeIcon?
	tween_icon.texture = $LikeIcon.texture
	add_child(tween_icon)
	tween.tween_property(tween_icon, "scale", Vector2(4, 4), 0.5)
	tween.tween_property(tween_icon, "scale", Vector2(2, 2), 0.5)
	tween.tween_callback(tween_icon.queue_free)
