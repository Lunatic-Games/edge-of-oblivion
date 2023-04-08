extends "res://Item/Item.gd"

# Attack right 1, 2, 3 spaces away
var targets = []

onready var arrow_effect_scene = preload("res://Data/Indicators/attack_effects/RangedAttackEffect.tscn")

func activateItem() -> void:
	attack_logic()
	yield(get_tree(), "idle_frame")

func attack_logic():
	targets = []
	
	var starting_tile = user.currentTile.rightTile
	
	if starting_tile:
		targets.append(starting_tile)
		
		var second_tile = starting_tile.rightTile
		if currentTier >= 2 && second_tile:
			targets.append(second_tile)
		
			var third_tile = second_tile.rightTile
			if currentTier >= 3 && third_tile:
				targets.append(third_tile)
	
	var count = 0
	for tile in targets:
		perform_attack(tile, count)
		count +=1

func perform_attack(tile_to_attack, offset) -> void:
	var enemy = tile_to_attack.occupied
	yield(get_tree().create_timer(0.12*offset), "timeout")
	var effect = spawn_arrow_effect(GameManager.player.currentTile, tile_to_attack)
	yield(effect, "effect_complete")
	if enemy && enemy.isEnemy():
		enemy.takeDamage(1)
		GameManager.player.heal(1)

func spawn_arrow_effect(starting_tile: Tile, ending_tile: Tile) -> Object:
	var effect = arrow_effect_scene.instance()
	effect.global_position = starting_tile.global_position
	effect.rotation_degrees = 0
	
	GameManager.gameboard.add_child(effect)
	effect.setup(starting_tile, ending_tile)
	return effect
