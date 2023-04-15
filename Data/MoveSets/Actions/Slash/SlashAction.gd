extends "res://Data/MoveSets/Actions/Action.gd"


func trigger(starting_tile: Tile) -> void:
	var tile_to_target: Tile = choose_target_tile(starting_tile)
	
	if tile_to_target and tile_to_target.occupant and tile_to_target.occupant == GameManager.player:
		var unit: Unit = tile_to_target.occupant
		spawn_slash_effect(tile_to_target)
		unit.take_damage(damage)
