extends Control

# preload scenes
var MenuDisplayScene = preload("res://MVP/MenuDisplayDrag.tscn")
var CatScene = preload("res://MVP/CatMVP.tscn")
var ParticleScene = preload("res://MVP/ScoreParticles.tscn")

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
var GREETING_MENU_POS = Vector2(90, 470)
var GREETING_MENU_SIZE = Vector2(300, 60)
var GREETING_MENU_COLOR = Color(0, 0.24, 0.3, 0.5)

var GREETING_MENU_SPACING = Vector2(24,10)

var cat_wait_time = 2

var ScoreIcon = load("res://Arts/reaction_like.png")
var score = 0

# node reference
var greeting_menu
var cat_counter
var cat_timer

func _ready():
	
	greeting_menu = $GreetingMenu
	cat_counter = $CatCounter
	cat_timer = $CatTimer
	
	# initiate menu
	greeting_menu.predefined_items = GREETING_ITEMS
	greeting_menu.item_spacing = GREETING_MENU_SPACING
	greeting_menu.populate_menu()
	greeting_menu.position = GREETING_MENU_POS
	greeting_menu.size = GREETING_MENU_SIZE
	greeting_menu.get_node("MenuColor").color = GREETING_MENU_COLOR

	# initiate timer
	cat_timer.connect("timeout", Callable(self, "_on_cat_timer_timeout"))
	cat_timer.wait_time = cat_wait_time
	cat_timer.one_shot = true
	
	# start timer to create cats
	cat_timer.start()


# Trigger cat creation by timeout
func _on_cat_timer_timeout():
	
	create_cat(CAT_LIST.pick_random())
		
		
# Add new cats to scene
func create_cat(cat_data):
	
	# create cat node
	var cat = CatScene.instantiate()
	cat.set_cat_data(cat_data)
	
	# place cat on specified location
	cat.position = Vector2(200, 250)
	
	# connect cat signal and add child
	cat.connect("cat_satisfied", Callable(self, "_on_cat_satisfied"))
	add_child(cat)
	cat_timer.stop()
	

func _on_cat_satisfied(cat):

	# show visual effects on cat
	
	# show visual effects toward score display
	var moving_icon = ParticleScene.instantiate()
	moving_icon.texture = ScoreIcon
	moving_icon.position = cat.position + cat_counter.size / 2
	add_child(moving_icon)
	var tween = get_tree().create_tween()
	var destination_pos = cat_counter.position + Vector2(0, cat_counter.size.y / 2)
	tween.tween_property(moving_icon, "position", destination_pos, 0.3)
	
	# trigger following actions on tween completion
	tween.connect("finished", Callable(self, "_on_cat_scored").bind(moving_icon, cat))


func _on_cat_scored(moving_icon, cat):
	
	# clean up visual fx
	remove_child(moving_icon)
	moving_icon.queue_free()
	
	# update score display
	score += 1
	cat_counter.text = str(score)
	
	# remove cat from scene
	# to do: update tracker data on hearts level
	remove_child(cat)
	cat.queue_free()
	
	# start accepting new cats
	cat_timer.start()
