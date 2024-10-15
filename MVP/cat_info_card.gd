extends Control


var MAX_VISIT = 3

var CAT_LIST = [
	{
		"id": "cat_001",
		"pet": 2,
		"canned_food": 1, 
		"dry_food": 1,
		"status": "idle",
		"visits": 3
	},
	{
		"id": "cat_002",
		"pet": -1,
		"canned_food": 1, 
		"dry_food": 1,
		"status": "idle",
		"visits": 1
	},
	{
		"id": "cat_003",
		"pet": 2,
		"canned_food": 1, 
		"dry_food": 1,
		"status": "idle",
		"visits": 0
	},
	{
		"id": "cat_004",
		"pet": 1,
		"canned_food": 2, 
		"dry_food": 1,
		"status": "idle",
		"visits": 2
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# hide()
	update_tilemap(CAT_LIST)


# Update tiles based on cat status
func update_tilemap(cat_data):
	
	var atlas_x
	var atlas_y
	var tile_x
	var tile_y
	var cat
	
	for i in range(len(cat_data)):
		
		cat = cat_data[i]
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
		
			 
			
