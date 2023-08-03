class_name EntityOccupancy
extends Object


signal move_animation_completed

var entity: Entity = null
var data: OccupancyData = null

var current_tile: Tile = null


func _init(p_entity: Entity, p_data: OccupancyData):
	entity = p_entity
	data = p_data


func move_to_tile(destination_tile: Tile) -> bool:
	if data.can_move_to_tile(destination_tile) == false:
		return false
	
	var destination_occupant: Entity = destination_tile.occupant
	if destination_occupant:
		var destination_occupancy: EntityOccupancy = destination_occupant.occupancy
		if destination_occupancy.blocking_behavior == OccupancyData.BlockingBehavior.OCCUPIED:
			var tile_to_displace_to: Tile = get_displace_tile(destination_tile)
			if tile_to_displace_to == null:
				return false
			
			destination_occupancy.move_to_tile(tile_to_displace_to)
		else:
			return false
			
	current_tile.occupant = null
	current_tile = destination_tile
	current_tile.occupant = entity
	
	var base_tween: Tween = entity.create_tween()
	base_tween.tween_property(entity, "global_position", current_tile.global_position, 0.20).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	var offset_tween: Tween = entity.create_tween()
	offset_tween.tween_property(entity.sprite, "position:y", -15.0, 0.10).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	offset_tween.tween_property(entity.sprite, "position:y", 15.0, 0.10).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	base_tween.finished.connect(_on_move_tween_finished, CONNECT_ONE_SHOT)
	return true


func get_displace_tile(base_tile: Tile) -> Tile:
	var possible_tiles: Array[Tile] = []
	if base_tile.top_tile && !base_tile.top_tile.occupant:
		possible_tiles.append(base_tile.top_tile)
	if base_tile.bottom_tile && !base_tile.bottom_tile.occupant:
		possible_tiles.append(base_tile.bottom_tile)
	if base_tile.left_tile && !base_tile.left_tile.occupant:
		possible_tiles.append(base_tile.left_tile)
	if base_tile.right_tile && !base_tile.right_tile.occupant:
		possible_tiles.append(base_tile.right_tile)
	
	if possible_tiles.size() > 0:
		return possible_tiles.pick_random()
	
	return null


func _on_move_tween_finished():
	move_animation_completed.emit()
