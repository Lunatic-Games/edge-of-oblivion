class_name Tile
extends Node2D

enum TILE_DIRECTION {
	up,
	down,
	left,
	right
}

var topTile
var bottomTile
var rightTile
var leftTile
var occupied: Occupant

func getTileInDirection(direction):
	match direction:
		MovementUtility.moveDirection.up:
			return topTile
		MovementUtility.moveDirection.down:
			return bottomTile
		MovementUtility.moveDirection.left:
			return leftTile
		MovementUtility.moveDirection.right:
			return rightTile

func get_tile_coords_to_tile(tile):
	var xpos = position.x - tile.position.x
	var ypos = position.y - tile.position.y
	return Vector2(xpos, ypos)

func getRandomEnemyOccupiedAdjacentTile():
	var occupiedAdjacentTiles = []
	
	if topTile && topTile.occupied && topTile.occupied.isEnemy():
		occupiedAdjacentTiles.append(topTile)
	
	if bottomTile && bottomTile.occupied && bottomTile.occupied.isEnemy():
		occupiedAdjacentTiles.append(bottomTile)
	
	if leftTile && leftTile.occupied && leftTile.occupied.isEnemy():
		occupiedAdjacentTiles.append(leftTile)
	
	if rightTile && rightTile.occupied && rightTile.occupied.isEnemy():
		occupiedAdjacentTiles.append(rightTile)
	
	if occupiedAdjacentTiles.size() == 0:
		return null
	
	var randomIndex = randi()%(occupiedAdjacentTiles.size())
	return occupiedAdjacentTiles[randomIndex]
	
func clearOccupant() -> void:
	occupied = null

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
