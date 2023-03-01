extends "res://Data/MoveSets/Actions/action.gd"

func trigger(starting_tile):
	var tile_to_target = choose_target_tile(starting_tile)
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
		var tile_coords = tile_to_target.get_tile_coords_to_tile(starting_tile)
		if tile_coords.x > 0:
			owner.moveToTile(tile_to_target.leftTile)
		if tile_coords.x < 0:
			owner.moveToTile(tile_to_target.rightTile)
		if tile_coords.y > 0:
			owner.moveToTile(tile_to_target.topTile)
		if tile_coords.y < 0:
			owner.moveToTile(tile_to_target.bottomTile)
		
		tile_to_target.occupied.takeDamage(damage)
	elif tile_to_target and !tile_to_target.occupied:
		owner.moveToTile(tile_to_target)
	elif tile_to_target and tile_to_target.occupied:
		# TODO Once we have a knockback system for enemies implemented allow it here!
		pass

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
