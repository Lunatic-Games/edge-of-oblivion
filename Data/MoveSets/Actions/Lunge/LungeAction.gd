extends "res://Data/MoveSets/Actions/Action.gd"

func trigger(starting_tile):
	var tile_to_target = choose_target_tile(starting_tile)
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
		var tile_coords = tile_to_target.get_tile_coords_to_tile(starting_tile)
		if tile_coords.x > 0:
			owner.move_to_tile(tile_to_target.left_tile)
		if tile_coords.x < 0:
			owner.move_to_tile(tile_to_target.right_tile)
		if tile_coords.y > 0:
			owner.move_to_tile(tile_to_target.top_tile)
		if tile_coords.y < 0:
			owner.move_to_tile(tile_to_target.bottom_tile)
		
		tile_to_target.occupied.take_damage(damage)
	
	elif tile_to_target:
		owner.move_to_tile(tile_to_target)

func player_based_targeting(starting_tile):
	var current_tile = starting_tile
	var tile_coords = starting_tile.get_tile_coords_to_tile(GameManager.player.current_tile)
	if (abs(tile_coords.x) >= abs(tile_coords.y)):
		if (tile_coords.x > 0):
			for x in min(max_range, abs(tile_coords.x/65)):
				current_tile = current_tile.left_tile
				if current_tile == null:
					break
		else:
			for x in min(max_range, abs(tile_coords.x/65)):
				current_tile = current_tile.right_tile
				if current_tile == null:
					break
	else:
		if (tile_coords.y > 0):
			for x in min(max_range, abs(tile_coords.y/65)):
				current_tile = current_tile.top_tile
				if current_tile == null:
					break
		else:
			for x in min(max_range, abs(tile_coords.y/65)):
				current_tile = current_tile.bottom_tile
				if current_tile == null:
					break
	
	return current_tile
