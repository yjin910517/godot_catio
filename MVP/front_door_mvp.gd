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
		"gift": "feather",
		"visits": 0
	},
	{
		"id": "cat_002",
		"pet": -1,
		"canned_food": 1, 
		"dry_food": 1,
		"status": "idle",
		"gift": "mouse",
		"visits": 0
	},
	{
		"id": "cat_003",
		"pet": 2,
		"canned_food": 1, 
		"dry_food": 1,
		"status": "idle",
		"gift": "leaf",
		"visits": 0
	},
	{
		"id": "cat_004",
		"pet": 1,
		"canned_food": 2, 
		"dry_food": 1,
		"status": "idle",
		"gift": "shell",
		"visits": 0
	}
]

var GIFT_LIST = {
	"feather": {
		"name": "Feather",
		"icon_file": load("res://Arts/gift_icon_feather.png"),
		"desc": "Exotic colors. how beautiful"
	},
	"mouse": {
		"name": "Mouse",
		"icon_file": load("res://Arts/cat_toy_002_mouse3.png"),
		"desc": "A white rat. still alive"
	},
	"shell": {
		"name": "Shell",
		"icon_file": load("res://Arts/gift_icon_shell.png"),
		"desc": "the treasure from the sea"
	},
	"leaf": {
		"name": "Leaf",
		"icon_file": load("res://Arts/gift_icon_leaf.png"),
		"desc": "beautiful autumn color"
	}
}

# define global varaibles
var MAX_VISIT = 1 # for testing

var INITIAL_CAMERA_POS = Vector2(0, -540)

var CAT_SPAWN_LOCATION = Vector2(200, 300)
var GIFT_SPAWN_LOCATION = Vector2(200, 350)
var GREETING_MENU_LOCATION= Vector2(90, 470)
var GIFT_INFO_CARD_LOCATION = Vector2(80,80)
var CAT_INFO_CARD_LOCATION = Vector2(80,80)

var ScoreIcon = load("res://Arts/reaction_like.png")

var cat_wait_time = 2
var score = 0

# node reference
@onready var backyard = $Backyard
@onready var game_camera = $GameCamera
@onready var greeting_menu = $GreetingMenu
@onready var cat_counter = $CatCounterNode
@onready var cat_timer = $CatTimer
@onready var bgm_player = $BGM
@onready var gift_spawn = $GiftSpawn
@onready var gift_info_card = $GiftInfoCard
@onready var gift_shelf = $GiftShelf
@onready var notebook_icon = $Notebook
@onready var cat_info_card = $CatInfoCard


# On node ready
func _ready():
	
	# initiate menu
	greeting_menu.hide()
	greeting_menu.predefined_items = GREETING_ITEMS
	greeting_menu.position = GREETING_MENU_LOCATION
	greeting_menu.populate_menu()

	# initiate timer
	cat_timer.connect("timeout", Callable(self, "_on_cat_timer_timeout"))
	cat_timer.wait_time = cat_wait_time
	cat_timer.one_shot = true
	
	# initiate cat counter
	cat_counter.hide()
	
	# initiate gift spawn
	gift_spawn.hide()
	gift_spawn.position = GIFT_SPAWN_LOCATION
	gift_spawn.connect("gift_opened", Callable(self, "_on_gift_opened"))
	
	# initiate gift info card
	gift_info_card.hide()
	gift_info_card.position = GIFT_INFO_CARD_LOCATION
	gift_info_card.z_index = 2
	gift_info_card.connect("gift_info_closed", Callable(self, "_on_gift_info_closed"))

	# initiate cat info card
	cat_info_card.hide()
	cat_info_card.position = CAT_INFO_CARD_LOCATION
	cat_info_card.z_index = 2

	# initiate camera
	# trigger game start when camera moved to main scene
	game_camera.connect("camera_done", Callable(self, "play"))
	
	# initiate notebook icon
	notebook_icon.hide()
	notebook_icon.connect("notebook_opened", Callable(self, "_on_cat_info_card_opened"))
	
	play_intro()


func play_intro():
	
	game_camera.position = INITIAL_CAMERA_POS
	backyard.start_sky_animations()
	await get_tree().create_timer(10).timeout
	# To do: intro dialogue box
	game_camera.sky_to_garden()
	

func play():
	# start the game
	cat_timer.start()
	bgm_player.play()
	greeting_menu.show()
	cat_counter.show()


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
	

# Trigger feedback when cat is satisfied with a visit
func _on_cat_satisfied(cat):
	
	# show visual effects toward score display
	var moving_icon = ParticleScene.instantiate()
	moving_icon.texture = ScoreIcon
	moving_icon.position = cat.position + cat.size / 2
	add_child(moving_icon)
	var tween = create_tween()
	var destination_pos = cat_counter.get_center()
	tween.tween_property(moving_icon, "position", destination_pos, 0.3)
	
	# trigger following actions on tween completion
	tween.connect("finished", Callable(self, "_on_cat_scored").bind(moving_icon, cat))


func _on_cat_scored(moving_icon, cat):
	
	# clean up visual fx
	remove_child(moving_icon)
	moving_icon.queue_free()
	
	# update score display
	score += 1
	cat_counter.set_score(score)
	
	# update cat visit count
	var cat_data = cat.get_cat_data()
	var current_visit = cat_data["visits"]
	current_visit += 1
	cat_data["visits"] = current_visit
	cat.set_cat_data(cat_data)

	# remove cat from scene
	cat.fade_out()
	
	# check visit count and display gift
	if current_visit == MAX_VISIT:
		await get_tree().create_timer(1).timeout
		gift_spawn.set_gift_content(cat_data["gift"])
		gift_spawn.show()
		gift_spawn.play_anime()
		
	else:
		# if no gift, start accepting new cats
		cat_timer.start()
		

# show gift info card	
func _on_gift_opened(gift):
	
	print("You just acquired gift: ", gift)
	
	# Hide gift box icon
	gift_spawn.set_gift_content(null)
	gift_spawn.hide()
	
	# Show gift detail info
	gift_info_card.set_display_data(GIFT_LIST[gift])
	gift_info_card.show()


# add gift display to background
func _on_gift_info_closed(gift_data):
	
	# Display gift in background
	gift_shelf.display_item(gift_data)
	
	# To do: add vfx to higlight new display
	
	# Restart cycle
	gift_info_card.hide()
	cat_timer.start()


# show cat info card
func _on_cat_info_card_opened():
	cat_info_card.display_card(CAT_LIST)
	# To do: add vfx and sound
