extends Node2D

# preload scenes
var MenuDisplayScene = preload("res://Scenes/MenuDisplay.tscn")

# To do: save data in separate file
var TOY_ITEMS = [
		{ "name": "Fish", "icon": load("res://Arts/cat_toy_001_fish1.png") },
		{ "name": "Mouse", "icon": load("res://Arts/cat_toy_002_mouse1.png") },
		{ "name": "Dancer", "icon": load("res://Arts/cat_toy_003_dancer1.png") }
	]
	
	
# define global varaibles
var TOY_MENU_SPACING = Vector2(15, 15)
var TOY_MENU_POS = Vector2(400, 320)
var TOY_MENU_SIZE = Vector2(120, 300)
var TOY_MENU_COLOR = Color(0, 0.24, 0.3, 1)


# To do: load initial data and dynamic generate each child in main
func _ready():
	$Reception.connect("reception_clicked", Callable(self, "_on_reception_clicked"))
	$Reception.connect("computer_icon_clicked", Callable(self, "_on_computer_icon_clicked"))
	$FrontDoor.connect("cat_ready_to_reception", Callable(self, "_on_cat_ready_to_reception").bind())
	# create the toy menu
	var toy_menu = MenuDisplayScene.instantiate()
	toy_menu.predefined_items = TOY_ITEMS
	toy_menu.item_spacing = TOY_MENU_SPACING
	toy_menu.populate_menu()
	toy_menu.position = TOY_MENU_POS
	toy_menu.size = TOY_MENU_SIZE
	toy_menu.get_node("MenuColor").color = TOY_MENU_COLOR
	add_child(toy_menu)
	toy_menu.name = "ToyMenuDisplay"


# Place selected items on playground
func _on_reception_clicked(clicked_pos):
	var selected_node = $ToyMenuDisplay.selected_item
	if selected_node:
		var scene_path = "res://Scenes/" + selected_node.name + ".tscn"
		var toy = load(scene_path)
		var toy_instance = toy.instantiate()
		toy_instance.position = clicked_pos
		$Reception.add_child(toy_instance)


# Move cat from front door to reception
func _on_cat_ready_to_reception(cat):
	
	# reset front door and its station
	$FrontDoor.disconnect("cat_clicked", Callable(self, "_on_cat_clicked"))
	var cat_station = cat.get_parent()
	cat_station.remove_child(cat)
	cat_station.vacancy = true
	cat_station.set_bar_length(1)
	cat_station.get_node("LikeBar").hide()
	
	# update cat data
	var cat_data = cat.get_cat_data()
	cat_data["room"] = "reception"
	cat.set_cat_data(cat_data)

	cat.position = $Reception.queue_end
	
	$Reception.add_child(cat)
	$Reception.cats_in_queue += 1
	$Reception.queue_end += $Reception.queue_space
	
	# start front door cat creation if the queue is not at capacity
	if $Reception.cats_in_queue <= 2:
		$FrontDoor/CatTimer.start()


func _on_computer_icon_clicked():
	pass
	# to do: show a new scene for examine room
