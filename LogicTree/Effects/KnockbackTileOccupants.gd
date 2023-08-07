@icon("res://Assets/art/logic-tree/effects/push.png")
class_name LT_KnockbackTileOccupants
extends LogicTreeEffect


enum Direction {
	AWAY_FROM_REFERENCE,
	TOWARDS_REFERENCE,
	UP,
	RIGHT,
	DOWN,
	LEFT
}

@export var tiles: LT_TileArrayVariable
@export var knockback_direction: Direction
@export var references_tiles: LT_TileArrayVariable
@export_range(1, 10, 1, "or_greater") var distance: int = 1
@export var distance_override: LT_IntVariable
@export_range(0, 10, 1, "or_greater") var damage_on_collide: int = 0
@export var damage_on_collide_override: LT_IntVariable


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")


func perform_behavior() -> void:
	if distance_override != null:
		distance = distance_override.value
	
	if damage_on_collide_override != null:
		damage_on_collide = damage_on_collide_override.value
	
	for tile in tiles.value:
		var occupant: Entity = tile.occupant as Entity
		if occupant == null:
			continue
		
		match knockback_direction:
			Direction.UP:
				apply_knockback(occupant, Vector2i.UP, distance, damage_on_collide)
			Direction.RIGHT:
				apply_knockback(occupant, Vector2i.RIGHT, distance, damage_on_collide)
			Direction.DOWN:
				apply_knockback(occupant, Vector2i.DOWN, distance, damage_on_collide)
			Direction.LEFT:
				apply_knockback(occupant, Vector2i.LEFT, distance, damage_on_collide)
			Direction.AWAY_FROM_REFERENCE:
				var direction = _get_average_direction_to_tile(tile)
				apply_knockback(occupant, direction, distance, damage_on_collide)
			Direction.TOWARDS_REFERENCE:
				var direction = -_get_average_direction_to_tile(tile)
				apply_knockback(occupant, direction, distance, damage_on_collide)


# Returns true if the entity was knocked back in the given direction
func apply_knockback(target: Entity, direction: Vector2i, knockback: int, 
		collision_damage: int = 0) -> bool:
	if target.occupancy.data.can_be_knockbacked() == false:
		return false
	
	var current_tile: Tile = target.occupancy.current_tile
	var next_tile: Tile = current_tile.get_tile_in_direction(direction)
	
	for i in knockback:
		if next_tile == null:
			if target.occupancy.data.can_be_pushed_off_map:
				var next_tile_position: Vector2 = current_tile.global_position
				next_tile_position +=  Vector2(current_tile.get_approximate_size() * direction)
				target.occupancy.do_move_animation(next_tile_position)
				target.health.deal_lethal_damage()
				return true
			return false
			
		var next_tile_occupant: Entity = next_tile.occupant as Entity
			
		# Try pushing into next occupant if there is one
		if next_tile_occupant and !next_tile_occupant.occupancy.data.can_be_collected(target.data):
			if target.health != null:
				target.health.take_damage(collision_damage)
				if target.health.is_alive() == false:
					target.occupancy.do_move_animation(next_tile.global_position)
			
			if next_tile_occupant.health != null:
				next_tile_occupant.health.take_damage(collision_damage)
				if next_tile_occupant.health.is_alive() == false:
					if target.health != null and target.health.is_alive():
						target.occupancy.move_to_tile(next_tile)
					else:
						target.occupancy.do_move_animation(next_tile.global_position)
			
			if target.health != null and target.health.is_alive() == false:
				return true
			if next_tile_occupant.health != null and next_tile_occupant.health.is_alive() == false:
				return true
			
			if apply_knockback(next_tile_occupant, direction, 1):
				return target.occupancy.move_to_tile(next_tile)
			else:
				return false
		
		# No next occupant, can just move
		else:
			target.occupancy.move_to_tile(next_tile)
			current_tile = next_tile
			next_tile = current_tile.get_tile_in_direction(direction)
	
	return true


func _get_average_direction_to_tile(tile: Tile) -> Vector2i:
	assert(references_tiles != null, "Reference tiles not set for '" + name + "'")
	
	var total_position: Vector2 = Vector2(0, 0)
	for ref_tile in references_tiles.value:
		total_position += ref_tile.get_world_distance_to_given_tile(tile)
	
	return LogicTreeDirectionUtility.get_direction_from_tile_offset(total_position)
