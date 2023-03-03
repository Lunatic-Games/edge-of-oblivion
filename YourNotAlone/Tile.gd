class_name Tile
extends Node2D

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