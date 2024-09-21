extends Control

var item_data = null # This will hold data about the item (e.g., name, icon, etc.)
var is_selected = false
signal item_clicked(menu_item) # Signal to notify when this item is clicked

# Called when the node is added to the scene
func _ready():
	# Connect the mouse click event
	connect("gui_input", Callable(self, "_on_gui_input"))

# Function to set the item data and icon
func set_item_data(data):
	item_data = data
	$Icon.texture = data.icon # Set the item icon from the data

# Function to handle mouse input
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("item_clicked", self) # Emit a signal when the item is clicked

# Function to handle item selection
func select():
	is_selected = true
	$ColorBackground.color = Color(1, 0.8, 0.8, 1)

# Function to handle item deselection
func deselect():
	is_selected = false
	$ColorBackground.color = Color(1, 0.8, 0.8, 0)
