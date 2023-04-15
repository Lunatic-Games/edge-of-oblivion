extends Node2D


class ScanResult:
	var tiles: Array[Tile]
	var occupants: Array[Occupant]
	
	func _init(scanned_tiles: Array[Tile], scanned_occupants: Array[Occupant]):
		tiles = scanned_tiles
		occupants = scanned_occupants


func scan_tile_radius(center_tile: Tile, radius: int) -> ScanResult:
	var tiles: Array[Tile] = []
	var occupants: Array[Occupant] = []
	var current_tile: Tile = center_tile
	
	# Scan all applicable tiles, append tile and tile occupant if any to arrays
	# Navigate left
	var left_distance: int = 0
	
	for _i in range(0, radius):
		var next_tile: Tile = current_tile.left_tile
		
		if next_tile:
			current_tile = next_tile
			left_distance += 1
		else:
			break
	
	# Navigate up
	var up_distance: int = 0
	
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
			var occupant: Occupant = current_tile.occupant
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


# Expects direction to be one of Vector2i.RIGHT, UP, etc.
func scan_in_direction(origin_tile: Tile, direction: Vector2i, count: int) -> ScanResult:
	assert(count > 0) #,"ERROR [ItemUtil]: Can't scan " + str(count) + " tiles")
		
	var tiles: Array[Tile] = []
	var occupants: Array[Occupant] = []
	
	var current_tile: Tile = origin_tile
	for _i in count:
		current_tile = current_tile.get_tile_in_direction(direction)
		
		if current_tile:
			tiles.append(current_tile)
			
			if current_tile.occupant != null:
				occupants.append(current_tile.occupant)
		
		else:
			break
	
	return ScanResult.new(tiles, occupants)
