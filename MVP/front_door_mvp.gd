extends Control

# preload scenes
var MenuDisplayScene = preload("res://MVP/MenuDisplayDrag.tscn")
var CatScene = preload("res://MVP/CatMVP.tscn")
var ParticleScene = preload("res://MVP/ScoreParticles.tscn")

# To do: save data in separate file
var GREETING_ITEMS = [
		{ "id": "canned_food", "name": "Canned Food", "icon": load("res://Arts/food_canned2.png") },
		{ "id": "dry_food", "name": "Dry Food", "icon": load("res://Arts/food_dry_bowl.png") },
		{ "id": "pet", "name": "Petting", "icon": load("res://Arts/petting_icon.png") }
	]
	
var CAT_LIST = [
	{
		"id": "cat_001",
		"pet": 2,
		"canned_food": 1, 
		"dry_food": 1,
		"status": "idle",
		"gift": "fish",
		"visits": 0
	},
	{
		"id": "cat_002",
		"pet": -1,
		"canned_food": 1, 
		"dry_food": 1,
		"status": "idle",
		"gift": "bird",
		"visits": 0
	},
	{
		"id": "cat_003",
		"pet": 2,
		"canned_food": 1, 
		"dry_food": 1,
		"status": "idle",
		"gift": "paw print",
		"visits": 0
	},
	{
		"id": "cat_004",
		"pet": 1,
		"canned_food": 2, 
		"dry_food": 1,
		"status": "idle",
		"gift": "yarn",
		"visits": 0
	}
]

# define global varaibles
var MAX_VISIT = 3
var CAT_SPAWN_LOCATION = Vector2(200, 250)
var GIFT_SPAWN_LOCATION = Vector2(200, 350)
	
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
var bgm_player
var gift_spawn


# On node ready
func _ready():
	
	greeting_menu = $GreetingMenu
	cat_counter = $CatCounter
	cat_timer = $CatTimer
	bgm_player = $BGM
	gift_spawn = $GiftSpawn
	
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
	
	# play bgm
	bgm_player.play()
	
	# initiate gift spawn
	gift_spawn.position = GIFT_SPAWN_LOCATION
	gift_spawn.hide()
	gift_spawn.connect("gift_opened", Callable(self, "_on_gift_opened"))


# Trigger cat creation by timeout
func _on_cat_timer_timeout():
	
	create_cat(CAT_LIST.pick_random())
		
		
# Add new cats to scene
func create_cat(cat_data):
	
	# create cat node
	var cat = CatScene.instantiate()
	cat.set_cat_data(cat_data)
	
	# place cat on specified location
	cat.position = CAT_SPAWN_LOCATION
	
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
	
	# update cat visit count
	var cat_data = cat.get_cat_data()
	cat_data["visits"] += 1
	cat.set_cat_data(cat_data)

	# remove cat from scene
	cat.fade_out()
	
	# check visit count and display gift
	if cat_data["visits"] == MAX_VISIT:
		await get_tree().create_timer(1).timeout
		gift_spawn.set_gift_content(cat_data["gift"])
		gift_spawn.show()
		gift_spawn.play_anime()
		
	else:
		# if no gift, start accepting new cats
		cat_timer.start()
		
	
func _on_gift_opened(gift):
	print("You just acquired gift: ", gift)
	gift_spawn.set_gift_content(null)
	gift_spawn.hide()
	# To do: show gift info card
	# To do: add gift display to main scene and highlight
	cat_timer.start()
