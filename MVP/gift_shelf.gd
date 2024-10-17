extends Control


var display_counter

var ShelfItemScene = preload("res://MVP/ShelfItem.tscn")


var POS_DICT = {
	0: Vector2(0, 40),
	1: Vector2(80, 0),
	2: Vector2(90, 80),
	3: Vector2(160, 30)
}


func _ready():
	display_counter = 0


func display_item(gift_data):
	
	var pos = POS_DICT[display_counter]
	var display = ShelfItemScene.instantiate()
	add_child(display)
	display.set_display_data(pos, gift_data)
	display.show()
	
	display_counter += 1
	
	if display_counter == 4:
		pass
		# trigger game milestone and unlock next challenge
