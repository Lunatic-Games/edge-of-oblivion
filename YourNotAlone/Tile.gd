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
