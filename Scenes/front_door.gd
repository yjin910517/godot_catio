extends Control

signal cat_ready_to_reception(cat)


# Preload scenes
var CatScene = preload("res://Scenes/Cat.tscn")
var StationScene = preload("res://Scenes/Station.tscn")

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


# custom scene attributes
var station_pos_array = [Vector2(50, 230), Vector2(260, 230)]
var cat_wait_time = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# initiate stations
	var station
	for i in range(len(station_pos_array)):
		station = StationScene.instantiate()
		station.hide_like_bar()
		station.position = station_pos_array[i]
		add_child(station)
		station.name = "S" + str(i)
		
	# initiate menu
	var greeting_menu = $GreetingMenu
	greeting_menu.predefined_items = GREETING_ITEMS
	greeting_menu.item_spacing = GREETING_MENU_SPACING
	greeting_menu.populate_menu()
	greeting_menu.position = GREETING_MENU_POS
	greeting_menu.size = GREETING_MENU_SIZE
	greeting_menu.get_node("MenuColor").color = GREETING_MENU_COLOR
	
	# initiate timer
	$CatTimer.connect("timeout", Callable(self, "_on_cat_timer_timeout"))
	$CatTimer.wait_time = cat_wait_time
	$CatTimer.one_shot = false
	# start timer to create cats
	$CatTimer.start()
	

# Trigger cat creation by timeout
func _on_cat_timer_timeout():
	
	var station_node
	var has_vacancy = false

	# find an available station for cat creation
	for i in range(len(station_pos_array)):
		var station_name = "S" + str(i)
		station_node = get_node(station_name)
		if station_node.vacancy == true:
			create_cat(CAT_LIST.pick_random(), station_node)
			has_vacancy = true
			break

	# if no available station is found, stop the timer
	if has_vacancy == false:
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
	station.show_like_bar()


# Interact with the cat and show reaction
func _on_cat_clicked(cat):

	var selected_node = $GreetingMenu.selected_item
	var like_score = 0
	var cat_station = cat.get_parent()
	var bar_length = cat_station.get_bar_length()
	
	# get cat preference
	if selected_node:
		if selected_node.name == 'Petting':
			like_score = cat.get_cat_data("pet")
		else: 
			like_score = cat.get_cat_data("food")[selected_node.name]
		
	# calculate current like score
	bar_length += like_score * BAR_MAX_LEN / LIKE_MAX_SCORE
	if bar_length < 0: 
		bar_length = 0
	if bar_length > BAR_MAX_LEN:
		bar_length =  BAR_MAX_LEN

	# update bar length and display cat reaction
	var cat_reaction = cat.get_reaction(like_score)
	cat_station.set_bar_length(bar_length)
	cat_station.run_bar_animation(cat_reaction)
	await cat.show_reaction(cat_reaction)
	
	# emit signal if cat is ready to move
	if bar_length == BAR_MAX_LEN:
		emit_signal("cat_ready_to_reception", cat)
		cat.reaction_enabled = false
