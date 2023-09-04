class_name EntityOccupancy
extends RefCounted


signal move_animation_completed
signal collected(by: Entity)

var entity: Entity = null
var data: OccupancyData = null

var primary_tile: Tile = null
var additional_tiles: Array[Tile] = []


func _init(p_entity: Entity, p_data: OccupancyData, start_tile: Tile = null):
	entity = p_entity
	data = p_data
	
	if start_tile != null:
		start_tile.occupant = entity
		primary_tile = start_tile
		if p_data.size == OccupancyData.EntitySize.LARGE:
			assert(p_data.blocking_behavior == OccupancyData.BlockingBehavior.IMMOVABLE,
				"Currently entities that are set to LARGE need to be set to IMMOVABLE")
			add_additional_tiles_for_large_size()
		entity.global_position = start_tile.global_position


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
	

	if primary_tile.occupant == entity:  # Might not be occupant if it's a collectable being moved
		primary_tile.occupant = null
	primary_tile = destination_tile
	primary_tile.occupant = entity
	
	if collectable != null:
		collectable.occupancy.collect(entity)
	
	do_move_animation(primary_tile.global_position)
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
	offset_tween.tween_property(entity.sprite_container, "position:y", -15.0, 0.10).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	offset_tween.tween_property(entity.sprite_container, "position:y", 15.0, 0.10).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	base_tween.finished.connect(_on_move_tween_finished, CONNECT_ONE_SHOT)


func get_displace_tile() -> Tile:
	var possible_tiles: Array[Tile] = []
	if primary_tile.top_tile && can_move_to_tile(primary_tile.top_tile):
		possible_tiles.append(primary_tile.top_tile)
	if primary_tile.bottom_tile && can_move_to_tile(primary_tile.bottom_tile):
		possible_tiles.append(primary_tile.bottom_tile)
	if primary_tile.left_tile && can_move_to_tile(primary_tile.left_tile):
		possible_tiles.append(primary_tile.left_tile)
	if primary_tile.right_tile && can_move_to_tile(primary_tile.right_tile):
		possible_tiles.append(primary_tile.right_tile)
	
	if possible_tiles.size() > 0:
		return possible_tiles.pick_random()
	
	return null


func collect(collector: Entity):
	collected.emit(collector)


func add_additional_tiles_for_large_size():
	additional_tiles.append_array(
		[primary_tile.top_tile, primary_tile.right_tile,
		primary_tile.bottom_tile, primary_tile.left_tile]
	)
	
	for tile in additional_tiles:
		assert(tile != null, "Not enough tile space to spawn a large enemy")
	
	additional_tiles.append_array([
		additional_tiles[0].right_tile, additional_tiles[0].left_tile,
		additional_tiles[2].right_tile, additional_tiles[2].left_tile
	])
	for tile in additional_tiles:
		assert(tile != null, "Not enough tile space to spawn a large enemy")
		assert(tile.occupant == null, "Not enough room to spawn large enemy")
		tile.occupant = entity


func _on_move_tween_finished():
	move_animation_completed.emit()
