extends Node2D

class ScanResult:
	var tiles: Array
	var occupants: Array
	
	func _init(passed_tiles: Array,passed_occupants: Array):
		tiles = passed_tiles
		occupants = passed_occupants


func scan_tile_radius(center_tile: Tile, radius: int) -> ScanResult:
	var tiles: Array = []
	var occupants: Array = []
	#Scan all applicable tiles, append tile and tile occupant if any to arrays
	var current_tile: Tile = center_tile
	# Navigate left
	var left_distance: int = 0
	var up_distance: int = 0
	for _i in range(0, radius):
		var next_tile: Tile = current_tile.left_tile
		if next_tile:
			current_tile = next_tile
			left_distance += 1
		else:
			break
	# Navigate up
	for _i in range(0, radius):
		var next_tile: Tile = current_tile.top_tile
		if next_tile:
			current_tile = next_tile
			up_distance += 1
		else:
			break
	# Begin scanning by row
	for _i in range(-up_distance, radius + 1):
		var row_width: int = 0
		for _j in range(-left_distance, radius + 1):
			if not current_tile:
				continue
			tiles.append(current_tile)
			#Check occupant
			var occupant: Occupant = current_tile.occupied
			if occupant:
				occupants.append(occupant)
			#Move to next tile
			var next_tile: Tile = current_tile.right_tile
			if next_tile:
				current_tile = next_tile
				row_width += 1
			else:
				break
		#Slide to begining of row
		for _j in range(0, row_width):
			var next_tile: Tile = current_tile.left_tile
			if next_tile:
				current_tile = next_tile
			else:
				break
		var next_tile: Tile = current_tile.bottom_tile
		if next_tile:
			current_tile = next_tile
		else:
			break
	return ScanResult.new(tiles,occupants)

func scan_in_direction(origin_tile: Tile, direction: String, count: int) -> ScanResult:
	var tiles: Array = []
	var occupants: Array = []
	var current_tile: Tile = origin_tile
	assert(count > 0) #,"ERROR [ItemUtil]: Can't scan " + str(count) + " tiles")
	for _i in range(count):
		match direction:
			"up":
				current_tile = current_tile.top_tile
			"down":
				current_tile = current_tile.bottom_tile
			"left":
				current_tile = current_tile.left_tile
			"right":
				current_tile = current_tile.right_tile
		if current_tile:
			tiles.append(current_tile)
		else:
			break
		var next_tile: Tile
		match direction:
			"up":
				next_tile = current_tile.top_tile
			"down":
				next_tile = current_tile.bottom_tile
			"left":
				next_tile = current_tile.left_tile
			"right":
				next_tile = current_tile.right_tile
		if not next_tile:
			break
	return ScanResult.new(tiles, occupants)
