extends Control


var displayed_gift_data


func _ready():
	pass


# update texture and display location
func set_display_data(pos, frame, gift_data):
	
	displayed_gift_data = gift_data
	
	position = pos
	# Pop doesn't delete elements from reference. Need a different way to avoid repeat frames
	$Frame.texture = frame
	$Display.texture = gift_data["icon_file"]
	
	
