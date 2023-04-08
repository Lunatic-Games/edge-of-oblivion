extends "res://Data/MoveSets/Actions/action.gd"

func trigger(starting_tile: Tile) -> void:
	var tile_to_target: Tile = choose_target_tile(starting_tile)
	
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
		var unit = tile_to_target.occupied
		spawn_slash_effect(tile_to_target)
		tile_to_target.occupied.takeDamage(damage)
