class_name Tile
extends Node2D


signal update_triggered

const TILE_SIZE: float = 65.0

var top_tile: Tile
var bottom_tile: Tile
var right_tile: Tile
var left_tile: Tile
var occupant: Occupant


func update():
	update_triggered.emit()
	GlobalLogicTreeSignals.tile_update_triggered.emit(self)


# Expects direction to be one of Vector2i.UP, RIGHT, etc.
func get_tile_in_direction(direction: Vector2i) -> Tile:
	match direction:
		Vector2i.UP:
			return top_tile
		Vector2i.DOWN:
			return bottom_tile
		Vector2i.LEFT:
			return left_tile
		Vector2i.RIGHT:
			return right_tile
	
	return null


func get_direction_to_tile(tile: Tile) -> Vector2i:
	var offset: Vector2 = get_2d_distance_to_tile(tile)
	
	if offset.y == 0 && offset.x > 0:
		return Vector2i.RIGHT
	elif offset.y == 0 && offset.x < 0:
		return Vector2i.LEFT
	elif offset.x == 0 && offset.y < 0:
		return Vector2i.DOWN
	elif offset.x == 0 && offset.y > 0:
		return Vector2i.UP
	
	return Vector2i.ZERO


func get_2d_distance_to_tile(tile: Tile) -> Vector2:
	return tile.global_position - global_position


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
	
	if occupied_adjacent_tiles.is_empty():
		return null
	
	return occupied_adjacent_tiles.pick_random()


func clear_occupant() -> void:
	occupant = null
	if not GameManager.unoccupied_tiles.has(self):
		GameManager.unoccupied_tiles.append(self)


func is_tile_n_tiles_away(tile: Tile, number: int, allow_adjacent: bool = false) -> bool:
	var tile_coords: Vector2 = get_2d_distance_to_tile(tile)
	var x_distance: float = abs(tile_coords.x) / TILE_SIZE
	var y_distance: float = abs(tile_coords.y) / TILE_SIZE
	
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


func get_adjacent_tiles() -> Array[Tile]:
	return [top_tile, right_tile, bottom_tile, left_tile]


func get_adjacent_occupied_tiles() -> Array[Tile]:
	var occupied_tiles: Array[Tile] = []
	
	for tile in get_adjacent_tiles():
		if tile != null and tile.occupant:
			occupied_tiles.append(tile)
	
	return occupied_tiles
