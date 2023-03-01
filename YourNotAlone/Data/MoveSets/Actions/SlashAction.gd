extends "res://Data/MoveSets/Actions/action.gd"

func trigger(starting_tile):
	var tile_to_target = choose_target_tile(starting_tile)
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
		tile_to_target.occupied.takeDamage(damage)
