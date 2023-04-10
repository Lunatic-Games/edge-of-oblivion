class_name Action
extends Node2D

enum TargetingType {
	RANDOM,
	PLAYER_BASED,
	UP,
	DOWN,
	LEFT,
	RIGHT
}

const SLASH_EFFECT_SCENE = preload("res://Data/Particles/Attack/SlashParticles.tscn")
const ARROW_EFFECT_SCENE = preload("res://Data/Indicators/AttackEffects/RangedAttackEffect.tscn")

const EFFECT_MODULATE = Color("c69fa5")

@export var indicator_scene: PackedScene = preload("res://Data/Indicators/Indicator.tscn")
@export var targeting_type: TargetingType = TargetingType.RANDOM
@export var damage: int = 1
@export_range(0, 999, 1, "or_greater") var min_range: int = 1
@export_range(0, 999, 1, "or_greater") var max_range: int = 1
@export var prefer_hitting_player: bool = true


func indicate(starting_tile) -> void:
	var tile_to_indicate = choose_target_tile(starting_tile)
	
	if tile_to_indicate != null:
		var indicator = indicator_scene.instantiate()
		indicator.global_position = tile_to_indicate.global_position
		GameManager.gameboard.add_child(indicator)


func trigger(starting_tile) -> void:
	var tile_to_target = choose_target_tile(starting_tile)
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == GameManager.player:
		tile_to_target.occupied.take_damage(damage)


# Implement per action
func trigger_effect():
	pass


# TODO: Implement other targeting types
func choose_target_tile(starting_tile):
	var current_tile = starting_tile
	
	if targeting_type == TargetingType.RANDOM:
		pass
	
	if targeting_type == TargetingType.PLAYER_BASED:
		current_tile = player_based_targeting(starting_tile)
	
	for x in max_range:
		if targeting_type == TargetingType.UP:
			if current_tile.top_tile:
				current_tile = current_tile.top_tile
			
		if targeting_type == TargetingType.DOWN:
			if current_tile.bottom_tile:
				current_tile = current_tile.bottom_tile
			
		if targeting_type == TargetingType.LEFT:
			if current_tile.left_tile:
				current_tile = current_tile.left_tile
			
		if targeting_type == TargetingType.RIGHT:
			if current_tile.right_tile:
				current_tile = current_tile.right_tile
		
		var current_tile_has_player: bool = (current_tile and current_tile.occupied
			and current_tile.occupied == GameManager.player)
		
		if prefer_hitting_player and current_tile_has_player:
			break
	
	if current_tile == starting_tile and min_range > 0:
		return null
	
	return current_tile


# Implement per action that requires player based targeting!
func player_based_targeting(_starting_tile: Tile):
	pass


func spawn_slash_effect(tile: Tile) -> void:
	var effect = SLASH_EFFECT_SCENE.instantiate()
	effect.global_position = tile.global_position
	effect.modulate = EFFECT_MODULATE
	
	match TargetingType:
		TargetingType.DOWN:
			effect.rotation_degrees = 45
		TargetingType.UP:
			effect.rotation_degrees = 60
		TargetingType.LEFT:
			effect.rotation_degrees = 180
		TargetingType.RIGHT:
			effect.rotation_degrees = 0
	
	GameManager.gameboard.add_child(effect)


func spawn_arrow_effect(starting_tile: Tile, ending_tile: Tile) -> Object:
	var effect = ARROW_EFFECT_SCENE.instantiate()
	GameManager.gameboard.add_child(effect)
	
	effect.global_position = starting_tile.global_position
	effect.modulate = EFFECT_MODULATE
	
	match targeting_type:
		TargetingType.DOWN:
			effect.rotation_degrees = 90
		TargetingType.UP:
			effect.rotation_degrees = -90
		TargetingType.LEFT:
			effect.rotation_degrees = 180
		TargetingType.RIGHT:
			effect.rotation_degrees = 0
	
	effect.setup(starting_tile, ending_tile)
	return effect
