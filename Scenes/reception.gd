extends Control

signal reception_clicked(clicked_pos)
signal computer_icon_clicked()

var cats_in_queue = 0
var queue_space = Vector2(20, 0)
var queue_end = Vector2(20,120)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GroundControl.connect("gui_input", Callable(self, "_on_ground_control_gui_input"))
	$Computer.connect("gui_input", Callable(self, "_on_computer_gui_input"))


# Receive click event from self, emit signal to main
func _on_ground_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("reception_clicked", event.position)


# Receive click event from self, emit signal to main
func _on_computer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("computer_icon_clicked")
