extends "res://Data/MoveSets/Actions/Action.gd"

func trigger(starting_tile):
	var tile_to_target = choose_target_tile(starting_tile)
	var unit_to_target
	var arrow_effect
	if tile_to_target:
		unit_to_target = tile_to_target.occupied
		arrow_effect = spawn_arrow_effect(starting_tile, tile_to_target)
	
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
		await arrow_effect.effect_complete
		unit_to_target.take_damage(damage)
