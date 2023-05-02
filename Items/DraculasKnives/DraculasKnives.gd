extends "res://Items/Item.gd"

#const ARROW_EFFECT_SCENE: PackedScene = preload("res://Data/Indicators/AttackEffects/RangedAttackEffect.tscn")

# Attack right 1, 2, 3 spaces away


func activate_item() -> void:
	attack_logic()
	await get_tree().process_frame


func attack_logic() -> void:
	var target_tiles: Array[Tile] = []
	
	var starting_tile: Tile = user.current_tile.right_tile
	
	if starting_tile:
		target_tiles.append(starting_tile)
		
		var second_tile: Tile = starting_tile.right_tile
		if current_tier >= 2 && second_tile:
			target_tiles.append(second_tile)
		
			var third_tile: Tile = second_tile.right_tile
			if current_tier >= 3 && third_tile:
				target_tiles.append(third_tile)
	
	var count: int = 0
	for tile in target_tiles:
		perform_attack(tile, count)
		count +=1


func perform_attack(tile_to_attack: Tile, offset: int) -> void:
	var enemy: Enemy = tile_to_attack.occupant
	await get_tree().create_timer(0.12 * offset).timeout
	
	var effect = spawn_arrow_effect(GameManager.player.current_tile, tile_to_attack)
	await effect.effect_completed
	
	if enemy != null && enemy.is_enemy():
		enemy.take_damage(1)
		GameManager.player.heal(1)


func spawn_arrow_effect(starting_tile: Tile, ending_tile: Tile) -> Object:
#	var effect = ARROW_EFFECT_SCENE.instantiate()
#	effect.global_position = starting_tile.global_position
#	effect.rotation_degrees = 0
#
#	GameManager.gameboard.add_child(effect)
#	effect.setup(starting_tile, ending_tile)
#	return effect
	return null
