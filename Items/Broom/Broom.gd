extends "res://Items/Item.gd"

var tiles

func activate_item() -> void:
	perform_attack()
	await get_tree().process_frame

func perform_attack():
	tiles = []
	
	for x in currentTier:
		var target = user.current_tile.getRandomEnemyOccupiedAdjacentTile()
		if !target || !target.occupied:
			return
		var enemy = target.occupied
		var direction_to_tile = user.current_tile.get_direction_to_tile(target)
		if direction_to_tile != "":
			spawn_hammer_indicator(target.global_position, false)
			apply_knockback(enemy, direction_to_tile, 1, 0)
