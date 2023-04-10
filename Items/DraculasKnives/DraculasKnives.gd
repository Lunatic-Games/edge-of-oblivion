extends "res://Items/Item.gd"

const ARROW_EFFECT_SCENE = preload("res://Data/Indicators/AttackEffects/RangedAttackEffect.tscn")

# Attack right 1, 2, 3 spaces away
var targets = []


func activate_item() -> void:
	attack_logic()
	await get_tree().process_frame

func attack_logic():
	targets = []
	
	var starting_tile = user.current_tile.right_tile
	
	if starting_tile:
		targets.append(starting_tile)
		
		var second_tile = starting_tile.right_tile
		if currentTier >= 2 && second_tile:
			targets.append(second_tile)
		
			var third_tile = second_tile.right_tile
			if currentTier >= 3 && third_tile:
				targets.append(third_tile)
	
	var count = 0
	for tile in targets:
		perform_attack(tile, count)
		count +=1

func perform_attack(tile_to_attack, offset) -> void:
	var enemy = tile_to_attack.occupied
	await get_tree().create_timer(0.12*offset).timeout
	var effect = spawn_arrow_effect(GameManager.player.current_tile, tile_to_attack)
	await effect.effect_complete
	if enemy && enemy.is_enemy():
		enemy.take_damage(1)
		GameManager.player.heal(1)

func spawn_arrow_effect(starting_tile: Tile, ending_tile: Tile) -> Object:
	var effect = ARROW_EFFECT_SCENE.instantiate()
	effect.global_position = starting_tile.global_position
	effect.rotation_degrees = 0
	
	GameManager.gameboard.add_child(effect)
	effect.setup(starting_tile, ending_tile)
	return effect
