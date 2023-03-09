extends Node2D

class ScanResult:
	var tiles: Array
	var occupants: Array
	func _init(passed_tiles: Array, passed_occupants: Array) -> void:
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
		var next_tile: Tile = current_tile.leftTile
		if next_tile:
			current_tile = next_tile
			left_distance += 1
		else:
			break
	# Navigate up
	for _i in range(0, radius):
		var next_tile: Tile = current_tile.topTile
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
			var next_tile: Tile = current_tile.rightTile
			if next_tile:
				current_tile = next_tile
				row_width += 1
			else:
				break
		#Slide to begining of row
		for _j in range(0, row_width):
			var next_tile: Tile = current_tile.leftTile
			if next_tile:
				current_tile = next_tile
			else:
				break
		var next_tile: Tile = current_tile.bottomTile
		if next_tile:
			current_tile = next_tile
		else:
			break
	return ScanResult.new(tiles,occupants)