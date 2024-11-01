extends Control

var ShelfItemScene = preload("res://MVP/ShelfItem.tscn")

var POS_DICT = {
	0: Vector2(0, 40),
	1: Vector2(80, 30),
	2: Vector2(160, 50),
	3: Vector2(240, 40)
}

var frame_list = [
	load("res://Arts/gift_frame_5.png"),
	load("res://Arts/gift_frame_6.png"),
	load("res://Arts/gift_frame_1.png"),
	load("res://Arts/gift_frame_2.png")
]

var frame_idx

func _ready():
	frame_idx = 0
	frame_list.shuffle()


func display_item(gift_data):
	
	var pos = POS_DICT[frame_idx]
	var frame = frame_list[frame_idx]
	frame_idx += 1
	
	var display = ShelfItemScene.instantiate()
	add_child(display)
	display.set_display_data(pos, frame, gift_data)
	display.show()
