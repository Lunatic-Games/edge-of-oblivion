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
		var occupant: Unit = tile.occupant as Unit
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

func apply_knockback(target: Unit, direction: Vector2i, knockback: int, collideDamage: int = 0) -> bool:
	if not target.is_alive() or knockback == 0:
		return true
		
	var current_tile: Tile = target.current_tile
	var next_tile: Tile = current_tile.get_tile_in_direction(direction)
	
	for i in knockback:
		if next_tile == null:
			# Fall off end of map
			target.fall()
			current_tile.clear_occupant()
			break
			
		var next_tile_occupant: Unit = next_tile.occupant
			
		# Try pushing into next occupant if there is one
		if next_tile_occupant:
			if target.damageable:
				target.take_damage(collideDamage)
			if next_tile_occupant.damageable:
				next_tile_occupant.take_damage(collideDamage)
			
			if next_tile_occupant.pushable:
				if apply_knockback(next_tile_occupant, direction, 1):
					target.move_to_tile(next_tile)
					if not target.is_alive():
						next_tile.clear_occupant()
					return true
				else:
					return false
			else:
				return false
		
		# No next occupant, can just move
		else:
			target.move_to_tile(next_tile)
			current_tile = next_tile
			next_tile = current_tile.get_tile_in_direction(direction)
	
	return true


func _get_average_direction_to_tile(tile: Tile) -> Vector2i:
	assert(references_tiles != null, "Reference tiles not set for '" + name + "'")
	
	var total_position: Vector2 = Vector2(0, 0)
	for ref_tile in references_tiles.value:
		total_position += ref_tile.get_2d_distance_to_tile(tile)
	
	var y_dominant: bool = abs(total_position.y) > abs(total_position.x)
	var x_dominant: bool = abs(total_position.x) > abs(total_position.y)
	
	if x_dominant:
		if total_position.x > 0.0:
			return Vector2i.RIGHT
		if total_position.x < 0.0:
			return Vector2i.LEFT
	
	if y_dominant:
		if total_position.y > 0.0:
			return Vector2i.DOWN
		if total_position.y < 0.0:
			return Vector2i.UP
	
	# Tied for up-right
	if total_position.x > 0.0 and total_position.y < 0.0:
		return [Vector2i.RIGHT, Vector2i.UP].pick_random()
	
	# Tied for down-right
	if total_position.x > 0.0 and total_position.y > 0.0:
		return [Vector2i.RIGHT, Vector2i.DOWN].pick_random()
	
	# Tied for down-left
	if total_position.x < 0.0 and total_position.y > 0.0:
		return [Vector2i.LEFT, Vector2i.DOWN].pick_random()
	
	# Tied for up-left
	if total_position.x < 0.0 and total_position.y < 0.0:
		return [Vector2i.LEFT, Vector2i.UP].pick_random()
	
	# No obvious direction
	return [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT].pick_random()
