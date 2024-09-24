extends Control

# preload scenes
var MenuDisplayScene = preload("res://Scenes/MenuDisplayDrag.tscn")

# To do: save data in separate file
var GREETING_ITEMS = [
		{ "name": "Canned Food", "icon": load("res://Arts/food_canned2.png") },
		{ "name": "Dry Food", "icon": load("res://Arts/food_dry_bowl.png") },
		{ "name": "Petting", "icon": load("res://Arts/petting_icon.png") }
	]
	
# define global varaibles
var GREETING_MENU_SPACING = Vector2(15,15)
var GREETING_MENU_POS = Vector2(90, 30)
var GREETING_MENU_SIZE = Vector2(240, 60)
var GREETING_MENU_COLOR = Color(0, 0.24, 0.3, 1)

var greeting_menu = null


func _ready():
	# establish signal connections
	greeting_menu = $GreetingMenu
	
	# initiate menu
	greeting_menu.predefined_items = GREETING_ITEMS
	greeting_menu.item_spacing = GREETING_MENU_SPACING
	greeting_menu.populate_menu()
	greeting_menu.position = GREETING_MENU_POS
	greeting_menu.size = GREETING_MENU_SIZE
	greeting_menu.get_node("MenuColor").color = GREETING_MENU_COLOR
