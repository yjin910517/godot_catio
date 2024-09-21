extends Control

signal cat_profile_submitted(submission_data)

# To do: the data will come from main
var toy_predefined_items = [
		{ "name": "Fish", "icon": load("res://Arts/cat_toy_001_fish1.png") },
		{ "name": "Mouse", "icon": load("res://Arts/cat_toy_002_mouse1.png") },
		{ "name": "Dancer", "icon": load("res://Arts/cat_toy_003_dancer1.png") }
	]

var color_options = [
	{ "name": "Tuxedo", "icon": load("res://Arts/color_icon_001.png") },
	{ "name": "Calico", "icon": load("res://Arts/color_icon_002.png") },
	{ "name": "Orange Tabby", "icon": load("res://Arts/color_icon_003.png") },
]

var cat_name = null
var cat_color = null
var selected_toys = []
var start_position = Vector2(230, 180)  # Starting position for the first checkbox
var offset_y = 30  # Vertical distance between each checkbox

# to do: add scripts to set color theme and positions
# Or use a custom defined theme??
func _ready() -> void:
	# text input for name
	$Name.expand_to_text_length = true
	
	# initialize the OptionButton with color options
	for color in color_options:
		$Color.add_item(color["name"], color["icon"])
	
	# generate checkbox for each toy option
	create_checkbox()

	# connect the button signal to the submit function
	$Button.connect("pressed", Callable(self, "_on_submit_button_pressed"))


func create_checkbox():
	var current_position = start_position

	for toy in toy_predefined_items:
		var checkbox = CheckBox.new()
		checkbox.text = toy["name"]
		checkbox.position = current_position
		add_child(checkbox)

		var icon_texture = TextureRect.new()
		icon_texture.texture = toy["icon"]
		icon_texture.expand_mode = 5
		icon_texture.stretch_mode = 5
		icon_texture.size = Vector2(30, 30)
		icon_texture.position = Vector2(current_position.x - 30, current_position.y)
		add_child(icon_texture)
		
		# Connect the 'toggled' signal to handle selection/deselection
		checkbox.connect("toggled", Callable(self, "_on_checkbox_toggled").bind(checkbox.text))

		# Update the position for the next checkbox (move down by offset_y)
		current_position.y += offset_y


func _on_checkbox_toggled(pressed, toy):
	if pressed:
		selected_toys.append(toy)
	else:
		selected_toys.erase(toy)


func _on_submit_button_pressed():
	cat_name = $Name.text
	# make sure there is a color selection
	if len($Color.get_selected_items()) == 1:
		cat_color = $Color.get_item_text($Color.get_selected_items()[0])
		
	var profile_data = {"name": cat_name, "color": cat_color, "toy": selected_toys}
	print(profile_data)
	emit_signal("cat_profile_submitted", profile_data)
