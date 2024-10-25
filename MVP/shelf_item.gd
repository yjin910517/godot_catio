extends Control


var displayed_gift_data

var FRAME_LIST = [
	load("res://Arts/gift_frame_1.png"),
	load("res://Arts/gift_frame_2.png"),
	load("res://Arts/gift_frame_3.png"),
	load("res://Arts/gift_frame_4.png")
]


func _ready():
	pass


# update texture and display location
func set_display_data(pos, gift_data):
	
	displayed_gift_data = gift_data
	
	position = pos
	FRAME_LIST.shuffle()
	# Pop doesn't delete elements from reference. Need a different way to avoid repeat frames
	$Frame.texture = FRAME_LIST.pop_front()
	$Display.texture = gift_data["icon_file"]
	
	
# To do: click on display item to zoom in for more info
	
	
