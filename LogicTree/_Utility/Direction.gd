class_name LogicTreeDirectionUtility
extends Object


static func get_direction_from_tile_offset(position_offset: Vector2) -> Vector2i:
	var y_dominant: bool = abs(position_offset.y) > abs(position_offset.x)
	var x_dominant: bool = abs(position_offset.x) > abs(position_offset.y)
	
	if x_dominant:
		if position_offset.x > 0.0:
			return Vector2i.RIGHT
		if position_offset.x < 0.0:
			return Vector2i.LEFT
	
	if y_dominant:
		if position_offset.y > 0.0:
			return Vector2i.DOWN
		if position_offset.y < 0.0:
			return Vector2i.UP
	
	# Tied for up-right
	if position_offset.x > 0.0 and position_offset.y < 0.0:
		return [Vector2i.RIGHT, Vector2i.UP].pick_random()
	
	# Tied for down-right
	if position_offset.x > 0.0 and position_offset.y > 0.0:
		return [Vector2i.RIGHT, Vector2i.DOWN].pick_random()
	
	# Tied for down-left
	if position_offset.x < 0.0 and position_offset.y > 0.0:
		return [Vector2i.LEFT, Vector2i.DOWN].pick_random()
	
	# Tied for up-left
	if position_offset.x < 0.0 and position_offset.y < 0.0:
		return [Vector2i.LEFT, Vector2i.UP].pick_random()
	
	# No obvious direction
	return [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT].pick_random()
