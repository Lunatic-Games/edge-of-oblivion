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
	if data.can_move_to_tile(destination_tile) == false:
		return false
	
	var destination_occupant: Entity = destination_tile.occupant
	var collectable: Entity = null
	
	if destination_occupant:
		var destination_occupancy: EntityOccupancy = destination_occupant.occupancy
		match destination_occupancy.data.blocking_behavior:
			OccupancyData.BlockingBehavior.STANDARD:
				var tile_to_displace_to: Tile = get_displace_tile(destination_tile)
				if tile_to_displace_to == null:
					return false
				
				destination_occupancy.move_to_tile(tile_to_displace_to)
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


func do_move_animation(destination: Vector2):
	var base_tween: Tween = entity.create_tween()
	base_tween.tween_property(entity, "global_position", destination, 0.20).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	var offset_tween: Tween = entity.create_tween()
	offset_tween.tween_property(entity.sprite, "position:y", -15.0, 0.10).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	offset_tween.tween_property(entity.sprite, "position:y", 15.0, 0.10).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	base_tween.finished.connect(_on_move_tween_finished, CONNECT_ONE_SHOT)


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


func collect(collector: Entity):
	collected.emit(collector)


func _on_move_tween_finished():
	move_animation_completed.emit()
