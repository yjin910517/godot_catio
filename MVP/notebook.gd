extends Control

signal notebook_opened()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("gui_input", Callable(self, "_on_gui_input"))


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("notebook_opened") # Emit a signal when the item is clicked


func play_anime():
	$IconAnime.play("shake")
	await get_tree().create_timer(1).timeout
	$IconAnime.stop()
	$NotebookIcon.rotation = 0
