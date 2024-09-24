extends Control


func _ready():
	pass
	# mouse_filter = Control.MOUSE_FILTER_PASS

# specify behavior when being dropped on
func _can_drop_data(position, data):
	return data.has("greet_item")

func _drop_data(position, data):
	var menu_item = data["greet_item"]
	print("Cat received ", menu_item.name)
