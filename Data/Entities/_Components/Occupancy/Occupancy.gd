class_name EntityOccupancy
extends Object


signal move_animation_completed
signal collected(by: Entity)

var entity: Entity = null
var data: OccupancyData = null

var current_tile: Tile = null


func _init(p_entity: Entity, p_data: OccupancyData):
	entity = p_entity
	data = p_data


func move_to_tile(destination_tile: Tile) -> bool:
	if can_move_to_tile(destination_tile) == false:
		return false
	
	var destination_occupant: Entity = destination_tile.occupant
	var collectable: Entity = null
	
	if destination_occupant:
		var destination_occupancy: EntityOccupancy = destination_occupant.occupancy
		match destination_occupancy.data.blocking_behavior:
			OccupancyData.BlockingBehavior.STANDARD:
				var tile_to_displace_to: Tile = destination_occupancy.get_displace_tile()
				if tile_to_displace_to == null:
					return false
				if destination_occupancy.move_to_tile(tile_to_displace_to) == false:
					return false
			OccupancyData.BlockingBehavior.IMMOVABLE:
				return false
			OccupancyData.BlockingBehavior.COLLECTABLE:
				collectable = destination_occupant
	
	current_tile.occupant = null
	current_tile = destination_tile
	current_tile.occupant = entity
	
	if collectable != null:
		collectable.occupancy.collect(entity)
	
	do_move_animation(current_tile.global_position)
	return true


func can_move_to_tile(tile: Tile) -> bool:
	var other_occupant: Entity = tile.occupant
	if other_occupant == null:
		return true
	
	var other_occupancy_data: OccupancyData = other_occupant.occupancy.data
	if other_occupancy_data.blocking_behavior == OccupancyData.BlockingBehavior.IMMOVABLE:
		return false
	
	if other_occupancy_data.can_be_collected(entity.data):
		return true
	
	return data.can_push_entities


func do_move_animation(destination: Vector2):
	var base_tween: Tween = entity.create_tween()
	base_tween.tween_property(entity, "global_position", destination, 0.20).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	var offset_tween: Tween = entity.create_tween()
	offset_tween.tween_property(entity.sprite, "position:y", -15.0, 0.10).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	offset_tween.tween_property(entity.sprite, "position:y", 15.0, 0.10).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	base_tween.finished.connect(_on_move_tween_finished, CONNECT_ONE_SHOT)


func get_displace_tile() -> Tile:
	var possible_tiles: Array[Tile] = []
	if current_tile.top_tile && can_move_to_tile(current_tile.top_tile):
		possible_tiles.append(current_tile.top_tile)
	if current_tile.bottom_tile && can_move_to_tile(current_tile.bottom_tile):
		possible_tiles.append(current_tile.bottom_tile)
	if current_tile.left_tile && can_move_to_tile(current_tile.left_tile):
		possible_tiles.append(current_tile.left_tile)
	if current_tile.right_tile && can_move_to_tile(current_tile.right_tile):
		possible_tiles.append(current_tile.right_tile)
	
	if possible_tiles.size() > 0:
		return possible_tiles.pick_random()
	
	return null


func collect(collector: Entity):
	collected.emit(collector)


func _on_move_tween_finished():
	move_animation_completed.emit()
