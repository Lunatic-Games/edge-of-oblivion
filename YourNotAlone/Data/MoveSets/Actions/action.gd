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
#export (int) var preferred_range = 1
#export (int) var min_range = 1
#export (int) var max_range = 2
export (int) var damage = 1

var tile_to_indicate

# TODO IMPLEMENT
# RANGE
# OTHER TARGET TYPES
func indicate(starting_tile) -> void:
	if targeting_type == TARGETING_TYPE.random:
		pass
	if targeting_type == TARGETING_TYPE.player_based:
		pass
	
	if targeting_type == TARGETING_TYPE.up:
		tile_to_indicate = starting_tile.topTile
		
	if targeting_type == TARGETING_TYPE.down:
		tile_to_indicate = starting_tile.bottomTile
		
	if targeting_type == TARGETING_TYPE.left:
		tile_to_indicate = starting_tile.leftTile
		
	if targeting_type == TARGETING_TYPE.right:
		tile_to_indicate = starting_tile.rightTile
	
	if tile_to_indicate != null:
		var indicator = indicator_scene.instance()
		indicator.global_position = tile_to_indicate.global_position
		get_tree().root.add_child(indicator) # TODO use gamemanager.board once the other branch is merged

func trigger(starting_tile) -> void:
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
	
	if tile_to_target and tile_to_target.occupied and tile_to_target.occupied == get_tree().get_nodes_in_group("player")[0]:
		tile_to_target.occupied.takeDamage(damage)
