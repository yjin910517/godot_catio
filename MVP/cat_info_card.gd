extends Control

var MAX_VISIT = 3

@onready var btn = $CloseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	btn.connect("pressed", Callable(self, "_on_button_pressed"))
	

# Close info card
func _on_button_pressed():
	hide()
	# To do: emit signal to main for other changes
	

# Show info card
func display_card(cat_list_data):
	update_tilemap(cat_list_data)
	show()


# Update tiles based on cat status
func update_tilemap(cat_list_data):
	
	var atlas_x
	var atlas_y
	var tile_x
	var tile_y
	var cat
	
	for i in range(len(cat_list_data)):
		
		cat = cat_list_data[i]
		tile_y = i
		tile_x = 0
		
		# display cat icon
		atlas_y = i
		if cat["visits"] > 0:
			atlas_x = 0
		else:
			atlas_x = 1
			
		$TileMap.set_cell(0, Vector2i(tile_x, tile_y), 2, Vector2i(atlas_x, atlas_y))
		
		# display visit count
		atlas_y = 4
		for j in range(1, MAX_VISIT + 1):
			tile_x = j
			if cat["visits"] >= j:
				atlas_x = 0
			else:
				atlas_x = 1
				
			$TileMap.set_cell(0, Vector2i(tile_x, tile_y), 2, Vector2i(atlas_x, atlas_y))
		
		# display gift status
		atlas_y = 5
		tile_x += 1
		if cat["visits"] >= MAX_VISIT:
			atlas_x = 0
		else:
			atlas_x = 1
			
		$TileMap.set_cell(0, Vector2i(tile_x, tile_y), 2, Vector2i(atlas_x, atlas_y))
		
			 
			
