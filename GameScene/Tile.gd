class_name Tile
extends Node2D

enum TILE_DIRECTION {
	up,
	down,
	left,
	right
}

var top_tile: Tile
var bottom_tile: Tile
var right_tile: Tile
var left_tile: Tile
var occupant: Occupant


func get_tile_in_direction(direction: MovementUtility.moveDirection) -> Tile:
	match direction:
		MovementUtility.moveDirection.up:
			return top_tile
		MovementUtility.moveDirection.down:
			return bottom_tile
		MovementUtility.moveDirection.left:
			return left_tile
		MovementUtility.moveDirection.right:
			return right_tile
	
	return null


func get_tile_coords_to_tile(tile: Tile) -> Vector2:
	# TODO: This gets the position from the passed tile to the this one, but is that's what expected?
	var xpos = position.x - tile.position.x
	var ypos = position.y - tile.position.y
	return Vector2(xpos, ypos)


func get_random_enemy_occupied_adjacent_tile() -> Tile:
	var occupied_adjacent_tiles = []
	
	if top_tile && top_tile.occupant && top_tile.occupant.is_enemy():
		occupied_adjacent_tiles.append(top_tile)
	
	if bottom_tile && bottom_tile.occupant && bottom_tile.occupant.is_enemy():
		occupied_adjacent_tiles.append(bottom_tile)
	
	if left_tile && left_tile.occupant && left_tile.occupant.is_enemy():
		occupied_adjacent_tiles.append(left_tile)
	
	if right_tile && right_tile.occupant && right_tile.occupant.is_enemy():
		occupied_adjacent_tiles.append(right_tile)
	
	if occupied_adjacent_tiles.size() == 0:
		return null
	
	return occupied_adjacent_tiles.pick_random()


func clear_occupant() -> void:
	occupant = null


func is_tile_n_tiles_away(tile: Tile, number: int, allow_adjacent: bool = false) -> bool:
	var tile_coords: Vector2 = get_tile_coords_to_tile(tile)
	var x_distance: float = abs(tile_coords.x) / 65.0
	var y_distance: float = abs(tile_coords.y) / 65.0
	
	if allow_adjacent:
		if min(x_distance, y_distance) <= number:
			return true
		else:
			return false
	else:
		if (x_distance + y_distance) <= number:
			return true
		else:
			return false


func get_distance_to_tile(tile: Tile, allow_adjacent: bool = false) -> int:
	var count: int = 0
	while !is_tile_n_tiles_away(tile, count, allow_adjacent):
		count += 1
	
	return count


func get_direction_to_tile(tile: Tile) -> String:
	var tile_coords: Vector2 = get_tile_coords_to_tile(tile)
	
	if tile_coords.y == 0 && tile_coords.x > 0:
		return "left"
	elif tile_coords.y == 0 && tile_coords .x < 0:
		return "right"
	elif tile_coords.x == 0 && tile_coords.y < 0:
		return "down"
	elif tile_coords.x == 0 && tile_coords.y > 0:
		return "up"
	
	return ""


func get_neighbor_from_direction_string(direction: String) -> Tile:
	match direction:
		"up":
			return top_tile
		"down":
			return bottom_tile
		"left":
			return left_tile
		"right":
			return right_tile
	return null


func get_adjacent_tiles() -> Array[Tile]:
	return [top_tile, right_tile, bottom_tile, left_tile]


func get_adjacent_occupied_tiles() -> Array[Tile]:
	var occupied_tiles: Array[Tile] = []
	
	for tile in get_adjacent_tiles():
		if tile != null and tile.occupant:
			occupied_tiles.append(tile)
	
	return occupied_tiles
