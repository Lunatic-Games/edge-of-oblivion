class_name Tile
extends Node2D

enum TILE_DIRECTION {
	up,
	down,
	left,
	right
}

var top_tile
var bottom_tile
var right_tile
var left_tile
var occupant: Occupant


func getTileInDirection(direction):
	match direction:
		MovementUtility.moveDirection.up:
			return top_tile
		MovementUtility.moveDirection.down:
			return bottom_tile
		MovementUtility.moveDirection.left:
			return left_tile
		MovementUtility.moveDirection.right:
			return right_tile


func get_tile_coords_to_tile(tile):
	var xpos = position.x - tile.position.x
	var ypos = position.y - tile.position.y
	return Vector2(xpos, ypos)


func get_random_enemy_occupied_adjacent_tile():
	var occupiedAdjacentTiles = []
	
	if top_tile && top_tile.occupant && top_tile.occupant.is_enemy():
		occupiedAdjacentTiles.append(top_tile)
	
	if bottom_tile && bottom_tile.occupant && bottom_tile.occupant.is_enemy():
		occupiedAdjacentTiles.append(bottom_tile)
	
	if left_tile && left_tile.occupant && left_tile.occupant.is_enemy():
		occupiedAdjacentTiles.append(left_tile)
	
	if right_tile && right_tile.occupant && right_tile.occupant.is_enemy():
		occupiedAdjacentTiles.append(right_tile)
	
	if occupiedAdjacentTiles.size() == 0:
		return null
	
	var randomIndex = randi()%(occupiedAdjacentTiles.size())
	return occupiedAdjacentTiles[randomIndex]


func clear_occupant() -> void:
	occupant = null


func is_tile_n_tiles_away(tile, number, allow_adjacent = false):
	var tile_coords = get_tile_coords_to_tile(tile)
	var x_distance = abs(tile_coords.x)/65
	var y_distance = abs(tile_coords.y)/65
	
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


func get_distance_to_tile(tile:Tile, allow_adjacent:bool = false) -> int:
	var count = 0
	while !is_tile_n_tiles_away(tile, count, allow_adjacent):
		count += 1
	
	return count


func get_direction_to_tile(tile) -> String:
	var tile_coords = get_tile_coords_to_tile(tile)
	
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
