extends Control

# preload scenes
var MenuDisplayScene = preload("res://Scenes/MenuDisplayDrag.tscn")
var CatScene = preload("res://MVP/CatMVP.tscn")

# To do: save data in separate file
var GREETING_ITEMS = [
		{ "name": "Canned Food", "icon": load("res://Arts/food_canned2.png") },
		{ "name": "Dry Food", "icon": load("res://Arts/food_dry_bowl.png") },
		{ "name": "Petting", "icon": load("res://Arts/petting_icon.png") }
	]
	
var CAT_LIST = [
	{
		"id": "cat_001",
		"toy": ["Fish"],
		"pet": 0,
		"food": {"Canned Food": 5, "Dry Food": 1},
		"status": "idle"
	},
	{
		"id": "cat_002",
		"toy": ["Mouse"],
		"pet": -1,
		"food": {"Canned Food": 0, "Dry Food": 3},
		"status": "idle"
	}
]
	
# define global varaibles
var GREETING_MENU_POS = Vector2(90, 30)
var GREETING_MENU_SIZE = Vector2(300, 60)
var GREETING_MENU_COLOR = Color(0, 0.24, 0.3, 1)

var GREETING_MENU_SPACING = Vector2(24,10)

var greeting_menu = null
var cat_wait_time = 2

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

	# initiate timer
	$CatTimer.connect("timeout", Callable(self, "_on_cat_timer_timeout"))
	$CatTimer.wait_time = cat_wait_time
	$CatTimer.one_shot = true
	# start timer to create cats
	$CatTimer.start()

	

# Trigger cat creation by timeout
func _on_cat_timer_timeout():
	
	create_cat(CAT_LIST.pick_random())
	$CatTimer.stop()
		
		
# Add new cats to scene
func create_cat(cat_data):
	
	# create cat node
	var cat = CatScene.instantiate()
	cat.set_cat_data(cat_data)
	
	# place cat on specified location
	cat.position = Vector2(200, 200)
	
	# connect cat signal and add child
	cat.connect("cat_greeted", Callable(self, "_on_cat_greeted"))
	add_child(cat)


# Interact with the cat and show reaction
func _on_cat_greeted(cat, greet_item):

	var selected_node = greet_item
	var like_score = 0
	
	# get cat preference
	if selected_node:
		if selected_node.name == 'Petting':
			like_score = cat.get_cat_data("pet")
		else: 
			like_score = cat.get_cat_data("food")[selected_node.name]
		
	# update bar length and display cat reaction
	var cat_reaction = cat.get_reaction(like_score)
	await cat.show_reaction(cat_reaction)
	
