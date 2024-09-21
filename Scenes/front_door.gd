extends Control

signal cat_ready_to_reception(cat)


# Preload the Cat scene
var CatScene = preload("res://Scenes/Cat.tscn")

# To do: save data in a separate data file
var CAT_LIST = [
	{
		"name": "Jessie",
		"id": "cat_001",
		"toy": ["Fish"],
		"pet": 0,
		"food": {"Canned Food": 5, "Dry Food": 1},
		"status": "idle",
		"room": "front_door"
	},
	{
		"name": "Tyler",
		"id": "cat_002",
		"toy": ["Mouse"],
		"pet": -1,
		"food": {"Canned Food": 0, "Dry Food": 3},
		"status": "idle",
		"room": "front_door"
	}
]

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

var BAR_MAX_LEN = 80.0 # maximum station like bar length (100% like)
var LIKE_MAX_SCORE = 10.0 # maximum cat greeting score (100% like)


# Called when the node enters the scene tree for the first time.
func _ready():

	# to do: dynamically create station nodes
	$Station1.get_node("LikeBar").hide()
	$Station2.get_node("LikeBar").hide()
	
	# initiate menu
	var greeting_menu = $GreetingMenu
	greeting_menu.predefined_items = GREETING_ITEMS
	greeting_menu.item_spacing = GREETING_MENU_SPACING
	print(greeting_menu.item_spacing)
	greeting_menu.populate_menu()
	greeting_menu.position = GREETING_MENU_POS
	greeting_menu.size = GREETING_MENU_SIZE
	greeting_menu.get_node("MenuColor").color = GREETING_MENU_COLOR
	
	# initiate timer
	$CatTimer.connect("timeout", Callable(self, "_on_cat_timer_timeout"))
	$CatTimer.one_shot = false
	# start timer to create cats
	$CatTimer.start()
	

# Trigger cat creation by timeout
func _on_cat_timer_timeout():
	if $Station1.vacancy == true:
		create_cat(CAT_LIST[0], $Station1)
	elif $Station2.vacancy == true:
		create_cat(CAT_LIST[1], $Station2)
	else:
		$CatTimer.stop()
		
		
# Add new cats to scene
func create_cat(cat_data, station):
	
	# create cat node
	var cat = CatScene.instantiate()
	cat.set_cat_data(cat_data)
	
	# place cat on top center of the station
	var pos_x = (station.size.x - cat.size.x) / 2
	var pos_y = -1 * cat.size.y
	cat.position = Vector2(pos_x, pos_y)
	
	# connect cat signal and add child
	cat.connect("cat_clicked", Callable(self, "_on_cat_clicked"))
	station.vacancy = false
	station.add_child(cat)
	
	# reset like bar on station
	station.set_bar_length(1)
	station.get_node("LikeBar").show()
	
	print("cat created: ", cat.get_cat_data())


# Interact with the cat and show reaction
func _on_cat_clicked(cat):

	var selected_node = $GreetingMenu.selected_item
	var like_score = 0
	
	# get cat preference
	if selected_node:
		if selected_node.name == 'Petting':
			like_score = cat.get_cat_data("pet")
		else: 
			like_score = cat.get_cat_data("food")[selected_node.name]
		
		# calculate current like score
		var bar_length = cat.get_parent().get_bar_length()
		bar_length += like_score * BAR_MAX_LEN / LIKE_MAX_SCORE
		if bar_length < 0: 
			bar_length = 0
		if bar_length > BAR_MAX_LEN:
			bar_length =  BAR_MAX_LEN
			emit_signal("cat_ready_to_reception", cat)
			cat.reaction_enabled = false
			print("cat is happy and ready to move")
			
		# update like bar length to reflect change
		cat.get_parent().set_bar_length(bar_length)
	
	# display cat reaction icon
	cat.show_reaction(cat.get_reaction(like_score))
