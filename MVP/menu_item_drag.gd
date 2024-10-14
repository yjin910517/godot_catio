extends Control

var item_data = null # This will hold data about the item (e.g., name, icon, etc.)
signal item_clicked(menu_item) # Signal to notify when this item is clicked

# Called when the node is added to the scene
func _ready():
	# Connect the mouse click event
	connect("gui_input", Callable(self, "_on_gui_input"))

# Get item data attributes
func get_item_data(attr = null):
	if attr:
		return item_data.get(attr)
	return item_data
	
# Function to set the item data and icon
func set_item_data(data):
	item_data = data
	$Icon.texture = data.icon # Set the item icon from the data

# Grab icon texture
func get_icon():
	return $Icon.texture
	
# Function to handle mouse input
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("item_clicked", self) # Emit a signal when the item is clicked

# Specify behavior when being dragged
func _get_drag_data(event):
	var drag_data = {"greet_item": self}
	var preview = TextureRect.new()
	preview.texture = self.get_icon()
	set_drag_preview(preview)
	return drag_data
