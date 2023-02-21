extends Node2D

enum TARGETING_TYPE {
	random,
	player_based,
	up,
	down,
	left,
	right
}

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

# TODO IMPLEMENT
# OTHER TARGET TYPES
func choose_target_tile(starting_tile):
	if targeting_type == TARGETING_TYPE.random:
		pass
	if targeting_type == TARGETING_TYPE.player_based:
		pass
	
	var current_tile = starting_tile
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
