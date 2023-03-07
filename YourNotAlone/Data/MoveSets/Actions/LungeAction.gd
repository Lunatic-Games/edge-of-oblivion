extends "res://Data/MoveSets/Actions/action.gd"

func trigger(starting_tile):
	var tile_to_target = choose_target_tile(starting_tile)
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
		var tile_coords = tile_to_target.get_tile_coords_to_tile(starting_tile)
		if tile_coords.x > 0:
			owner.move_to_tile(tile_to_target.leftTile, owner.move_precedence)
		if tile_coords.x < 0:
			owner.move_to_tile(tile_to_target.rightTile, owner.move_precedence)
		if tile_coords.y > 0:
			owner.move_to_tile(tile_to_target.topTile, owner.move_precedence)
		if tile_coords.y < 0:
			owner.move_to_tile(tile_to_target.bottomTile, owner.move_precedence)
		
		tile_to_target.occupied.takeDamage(damage)
	
	elif tile_to_target:
		owner.move_to_tile(tile_to_target, owner.move_precedence)

func player_based_targeting(starting_tile):
	var current_tile = starting_tile
	var tile_coords = starting_tile.get_tile_coords_to_tile(GameManager.player.currentTile)
	if (abs(tile_coords.x) >= abs(tile_coords.y)):
		if (tile_coords.x > 0):
			for x in min(max_range, abs(tile_coords.x/65)):
				current_tile = current_tile.leftTile
				if current_tile == null:
					break
		else:
			for x in min(max_range, abs(tile_coords.x/65)):
				current_tile = current_tile.rightTile
				if current_tile == null:
					break
	else:
		if (tile_coords.y > 0):
			for x in min(max_range, abs(tile_coords.y/65)):
				current_tile = current_tile.topTile
				if current_tile == null:
					break
		else:
			for x in min(max_range, abs(tile_coords.y/65)):
				current_tile = current_tile.bottomTile
				if current_tile == null:
					break
	
	return current_tile
