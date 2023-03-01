extends Node2D

var topTile
var bottomTile
var rightTile
var leftTile
var occupied

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
