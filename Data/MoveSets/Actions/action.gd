extends Node2D

enum TARGETING_TYPE {
	random,
	player_based,
	up,
	down,
	left,
	right
}

const SLASH_EFFECT_SCENE = preload("res://Data/Particles/Attack/SlashParticles.tscn")
const ARROW_EFFECT_SCENE = preload("res://Data/Indicators/AttackEffects/RangedAttackEffect.tscn")

export (PackedScene) var indicator_scene = preload("res://Data/Indicators/Indicator.tscn")
export (TARGETING_TYPE) var targeting_type = TARGETING_TYPE.random
export (int) var damage = 1
export (int) var min_range = 1
export (int) var max_range = 1
export (bool) var preferred_hitting_player = true

func indicate(starting_tile) -> void:
	var tile_to_indicate = choose_target_tile(starting_tile)
	
	if tile_to_indicate != null:
		var indicator = indicator_scene.instance()
		indicator.global_position = tile_to_indicate.global_position
		GameManager.gameboard.add_child(indicator)

func trigger(starting_tile) -> void:
	var tile_to_target = choose_target_tile(starting_tile)
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
		tile_to_target.occupied.takeDamage(damage)

# Implement per action
func trigger_effect():
	pass

# TODO IMPLEMENT OTHER TARGET TYPES
func choose_target_tile(starting_tile):
	var current_tile = starting_tile
	
	if targeting_type == TARGETING_TYPE.random:
		pass
	
	if targeting_type == TARGETING_TYPE.player_based:
		current_tile = player_based_targeting(starting_tile)
	
	for x in max_range:
		if targeting_type == TARGETING_TYPE.up:
			if current_tile.topTile:
				current_tile = current_tile.topTile
			
		if targeting_type == TARGETING_TYPE.down:
			if current_tile.bottomTile:
				current_tile = current_tile.bottomTile
			
		if targeting_type == TARGETING_TYPE.left:
			if current_tile.leftTile:
				current_tile = current_tile.leftTile
			
		if targeting_type == TARGETING_TYPE.right:
			if current_tile.rightTile:
				current_tile = current_tile.rightTile
		
		if preferred_hitting_player && current_tile && current_tile.occupied && current_tile.occupied == GameManager.player:
			break
	
	if current_tile == starting_tile && min_range > 0:
		return null
	
	return current_tile

# Implement per action that requires player based targeting!
func player_based_targeting(starting_tile):
	pass

func spawn_slash_effect(tile: Tile) -> void:
	var effect = SLASH_EFFECT_SCENE.instance()
	effect.global_position = tile.global_position
	effect.modulate = Color("c69fa5")
	
	match targeting_type:
		TARGETING_TYPE.down:
			effect.rotation_degrees = 45
		TARGETING_TYPE.up:
			effect.rotation_degrees = 60
		TARGETING_TYPE.left:
			effect.rotation_degrees = 180
		TARGETING_TYPE.right:
			effect.rotation_degrees = 0
	
	GameManager.gameboard.add_child(effect)

func spawn_arrow_effect(starting_tile: Tile, ending_tile: Tile) -> Object:
	var effect = ARROW_EFFECT_SCENE.instance()
	effect.global_position = starting_tile.global_position
	effect.modulate = Color("c69fa5")
	
	match targeting_type:
		TARGETING_TYPE.down:
			effect.rotation_degrees = 90
		TARGETING_TYPE.up:
			effect.rotation_degrees = -90
		TARGETING_TYPE.left:
			effect.rotation_degrees = 180
		TARGETING_TYPE.right:
			effect.rotation_degrees = 0
	
	GameManager.gameboard.add_child(effect)
	effect.setup(starting_tile, ending_tile)
	return effect
