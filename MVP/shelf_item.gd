extends Control


var displayed_gift_data

var frame_list = [
	load("res://Arts/gift_frame_5.png"),
	load("res://Arts/gift_frame_6.png"),
	load("res://Arts/gift_frame_3.png"),
	load("res://Arts/gift_frame_4.png")
]

func _ready():
	pass


# update texture and display location
func set_display_data(pos, gift_data):
	
	displayed_gift_data = gift_data
	
	position = pos
	# Pop doesn't delete elements from reference. Need a different way to avoid repeat frames
	$Frame.texture = frame_list.pick_random()
	$Display.texture = gift_data["icon_file"]
	
	
