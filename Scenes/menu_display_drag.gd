extends Control

# Preload the MenuItem scene
var MenuItemScene = preload("res://Scenes/MenuItemDrag.tscn")

# Custom scene attributes
var predefined_items = []
var item_spacing = null
var selected_item = null


# Called when the scene is added to the tree
func _ready():
	pass


# Function to populate the menu with items and arrange them
func populate_menu():
	for i in range(predefined_items.size()):
		var item_data = predefined_items[i]
		var menu_item = MenuItemScene.instantiate() # Create a new MenuItem instance
		menu_item.set_item_data(item_data) # Set the item's data
		menu_item.name = item_data.name
		menu_item.connect("item_clicked", Callable(self, "_on_item_clicked")) # Connect the item click signal
		
		# Set the item's position based on its index in the grid
		menu_item.position.x = item_spacing.x + i * (menu_item.size.x + item_spacing.x)
		menu_item.position.y = item_spacing.y
		
		# Add the item as a child of MenuDisplay
		add_child(menu_item)


# Function to handle item clicks
func _on_item_clicked(menu_item):
	selected_item = menu_item
	print(name, " received selection: ", selected_item.name)
	