class_name OccupancyData
extends Resource


enum EntitySize {
	SMALL,
#	MEDIUM,
#	LARGE
}

enum BlockingBehavior {
	FREE_SPACE,
	STANDARD,
	IMMOVABLE
}

@export var size: EntitySize = EntitySize.SMALL
@export var blocking_behavior: BlockingBehavior = BlockingBehavior.STANDARD
@export var can_be_pushed_off_map: bool = true
@export var can_push_entities: bool = false


func can_move_to_tile(tile: Tile) -> bool:
	var other_occupant: Entity = tile.occupant
	if other_occupant == null:
		return true
	
	var other_occupancy_data: OccupancyData = other_occupant.occupancy.data
	if other_occupancy_data.blocking_behavior == BlockingBehavior.IMMOVABLE:
		return false
	
	if other_occupancy_data.behaves_like_open_tile():
		return true
	
	return can_push_entities


func behaves_like_open_tile():
	return blocking_behavior == BlockingBehavior.FREE_SPACE


func can_be_knockbacked() -> bool:
	match blocking_behavior:
		BlockingBehavior.FREE_SPACE:
			return false
		BlockingBehavior.STANDARD:
			return true
		BlockingBehavior.IMMOVABLE:
			return false
	return false
