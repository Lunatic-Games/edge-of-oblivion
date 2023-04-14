extends "res://Items/Item.gd"


func activate_item() -> void:
	perform_attack()
	await get_tree().process_frame


func perform_attack() -> void:
	for x in current_tier:
		var target_tile: Tile = user.current_tile.get_random_enemy_occupied_adjacent_tile()
		
		if !target_tile || !target_tile.occupant:
			return
		
		var direction_to_tile: Vector2i = user.current_tile.get_direction_to_tile(target_tile)
		
		if direction_to_tile != Vector2i.ZERO:
			spawn_hammer_indicator(target_tile.global_position, false)
			
			var enemy: Enemy = target_tile.occupant
			apply_knockback(enemy, direction_to_tile, 1, 0)
