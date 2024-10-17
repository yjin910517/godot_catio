extends Control

signal gift_info_closed(gift_data)

var btn
var icon_display_node
var toy_name_node
var toy_desc_node

var stored_gift_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	btn = $Button
	icon_display_node = $IconDisplay
	toy_name_node = $ToyName
	toy_desc_node = $ToyDesc
	
	btn.connect("pressed", Callable(self, "_on_button_pressed"))


func set_display_data(gift_data):
	
	stored_gift_data = gift_data
	icon_display_node.texture = gift_data["icon_file"]
	toy_name_node.text = gift_data["name"]
	toy_desc_node.text = gift_data["desc"]


func _on_button_pressed():
	emit_signal("gift_info_closed", stored_gift_data)
