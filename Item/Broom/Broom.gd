extends "res://Item/Item.gd"

var tiles

func activateItem() -> void:
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack():
	tiles = []
	
	for x in currentTier:
		var target = user.currentTile.getRandomEnemyOccupiedAdjacentTile()
		if !target || !target.occupied:
			return
		var enemy = target.occupied
		var direction_to_tile = user.currentTile.get_direction_to_tile(target)
		if direction_to_tile != "":
			spawn_hammer_indicator(target.global_position, false)
			applyKnockBack(enemy, direction_to_tile, 1, 0)
