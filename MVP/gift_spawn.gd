extends Control

signal gift_opened(gift)

var gift_content = null


func _ready():
	connect("gui_input", Callable(self, "_on_gui_input"))


# Update gift content
func set_gift_content(gift):
	gift_content = gift


# Play anime effect
func play_anime():
	$AnimationPlayer.play("Gift Icon Anime")


# Function to mouse click (gift open)
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("gift_opened", gift_content) # Emit a signal when the item is clicked
