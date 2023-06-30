class_name Tile
extends Node2D


signal update_triggered
signal occupied_by_new_occupant(occupant: Occupant)
signal no_longer_occupied

var top_tile: Tile
var bottom_tile: Tile
var right_tile: Tile
var left_tile: Tile

var occupant: Occupant : set = _set_occupant
var coord: Vector2i = Vector2i.ZERO


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


# Returns one of Vector2i.UP, RIGHT, etc. Returns Vector2i.ZERO if the same position
# NOTE: Doesn't support diagonals at the momement
func get_direction_to_tile(tile: Tile) -> Vector2i:
	var offset: Vector2 = get_coord_distance_to_given_tile(tile)
	
	if offset.y == 0 && offset.x > 0:
		return Vector2i.RIGHT
	elif offset.y == 0 && offset.x < 0:
		return Vector2i.LEFT
	elif offset.x == 0 && offset.y < 0:
		return Vector2i.DOWN
	elif offset.x == 0 && offset.y > 0:
		return Vector2i.UP
	
	return Vector2i.ZERO


func get_random_enemy_occupied_adjacent_tile() -> Tile:
	var occupied_adjacent_tiles = []
	
	for tile in get_adjacent_occupied_tiles():
		if tile.occupant is Enemy:
			occupied_adjacent_tiles.append(tile)
	
	if occupied_adjacent_tiles.is_empty():
		return null
	
	return occupied_adjacent_tiles.pick_random()


func get_coord_distance_to_given_tile(other_tile: Tile) -> Vector2i:
	return Vector2i(other_tile.coord - coord)


func get_world_distance_to_given_tile(other_tile: Tile) -> Vector2:
	return other_tile.global_position - global_position


func get_manhattan_coord_distance_to_given_tile(other_tile: Tile) -> int:
	return abs(other_tile.coord.x - coord.x) + abs(other_tile.coord.y - coord.y)


func get_adjacent_tiles() -> Array[Tile]:
	return [top_tile, right_tile, bottom_tile, left_tile]


func get_adjacent_occupied_tiles() -> Array[Tile]:
	var occupied_tiles: Array[Tile] = []
	
	for tile in get_adjacent_tiles():
		if tile != null and tile.occupant:
			occupied_tiles.append(tile)
	
	return occupied_tiles


func _set_occupant(new_occupant: Occupant):
	var occupant_before: Occupant = occupant
	occupant = new_occupant
	
	if occupant != null and occupant != occupant_before:
		occupied_by_new_occupant.emit(occupant)
	
	if occupant == null and occupant_before != null:
		no_longer_occupied.emit()
