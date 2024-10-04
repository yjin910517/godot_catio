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
var GREETING_MENU_POS = Vector2(90, 470)
var GREETING_MENU_SIZE = Vector2(300, 60)
var GREETING_MENU_COLOR = Color(0, 0.24, 0.3, 0.5)

var GREETING_MENU_SPACING = Vector2(24,10)

var greeting_menu = null
var cat_wait_time = 2

var ScoreIcon = load("res://Arts/reaction_like.png")
var score = 0

func _ready():
	
	# initiate menu
	greeting_menu = $GreetingMenu
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
	$CatTimer.stop()
	

func _on_cat_satisfied(cat):
	print("front door knows cat satisfied")
	
	# show visual effects after scoring
	var moving_icon = Sprite2D.new()
	moving_icon.texture = ScoreIcon
	moving_icon.scale = Vector2(2,2)
	moving_icon.position = cat.position
	add_child(moving_icon)
	var tween = get_tree().create_tween()
	tween.tween_property(moving_icon, "position", $CatCounter.position, 1)
	tween.tween_callback(moving_icon.queue_free)
	
	# update score display
	score += 1
	$CatCounter.text = str(score)
	
	# clean up
	remove_child(cat)
	cat.queue_free()
	
	# start accepting new cats
	$CatTimer.start()
