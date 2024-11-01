extends Control

# Preload the MenuItem scene
var MenuItemScene = preload("res://MVP/MenuItemDrag.tscn")

# Display setting
var ITEM_SPACING = Vector2(24,10)
var GREETING_MENU_SIZE = Vector2(300, 60)
var GREETING_MENU_COLOR = Color(0, 0.24, 0.3, 0.5)

# Custom scene attributes
var predefined_items = []
var selected_item = null

# Node reference
@onready var color_node = $MenuColor


# Called when the scene is added to the tree
func _ready():
	size = GREETING_MENU_SIZE
	color_node.color = GREETING_MENU_COLOR


# Function to populate the menu with items and arrange them
func populate_menu():
	for i in range(predefined_items.size()):
		var item_data = predefined_items[i]
		var menu_item = MenuItemScene.instantiate() # Create a new MenuItem instance
		menu_item.set_item_data(item_data) # Set the item's data
		menu_item.name = item_data.name
		menu_item.connect("item_clicked", Callable(self, "_on_item_clicked")) # Connect the item click signal
		
		# Set the item's position based on its index in the grid
		menu_item.position.x = ITEM_SPACING.x + i * (menu_item.size.x + ITEM_SPACING.x)
		menu_item.position.y = ITEM_SPACING.y
		
		# Add the item as a child of MenuDisplay
		add_child(menu_item)


# Function to handle item clicks
func _on_item_clicked(menu_item):
	selected_item = menu_item
	
