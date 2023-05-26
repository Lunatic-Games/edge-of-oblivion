extends "res://Data/MoveSets/Actions/Action.gd"


func trigger(starting_tile: Tile) -> void:
	var tile_to_target: Tile = choose_target_tile(starting_tile)
	
	if tile_to_target:
		var arrow_effect = spawn_arrow_effect(starting_tile, tile_to_target)
	
		if tile_to_target.occupant and tile_to_target.occupant == GameManager.player:
			await arrow_effect.effect_completed
			var unit_to_target: Unit = tile_to_target.occupant as Unit
			if unit_to_target:
				unit_to_target.take_damage(damage)
