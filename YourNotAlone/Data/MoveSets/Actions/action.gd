extends Node2D

enum TARGETING_TYPE {
	random,
	player_based,
	up,
	down,
	left,
	right
}

export (PackedScene) var indicator_scene = preload("res://Target.tscn")
export (TARGETING_TYPE) var targeting_type = TARGETING_TYPE.random
export (int) var damage = 1

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

# TODO IMPLEMENT
# RANGE
# OTHER TARGET TYPES
# export (int) var preferred_range = 1
# export (int) var min_range = 1
# export (int) var max_range = 2
func choose_target_tile(starting_tile):
	var tile_to_target
	
	if targeting_type == TARGETING_TYPE.random:
		pass
	if targeting_type == TARGETING_TYPE.player_based:
		pass
	
	if targeting_type == TARGETING_TYPE.up:
		tile_to_target = starting_tile.topTile
		
	if targeting_type == TARGETING_TYPE.down:
		tile_to_target = starting_tile.bottomTile
		
	if targeting_type == TARGETING_TYPE.left:
		tile_to_target = starting_tile.leftTile
		
	if targeting_type == TARGETING_TYPE.right:
		tile_to_target = starting_tile.rightTile
	
	return tile_to_target
