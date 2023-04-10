extends "res://Data/MoveSets/Actions/Action.gd"


func trigger(starting_tile):
	var tile_to_target = choose_target_tile(starting_tile)
	
	if tile_to_target:
		var unit_to_target = tile_to_target.occupied
		var arrow_effect = spawn_arrow_effect(starting_tile, tile_to_target)
	
		if tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
			await arrow_effect.effect_complete
			unit_to_target.take_damage(damage)
