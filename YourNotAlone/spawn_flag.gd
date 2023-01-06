extends "res://occupant.gd"

var currentTile

func _ready():
	occupantType = occupantTypes.collectable

func collect():
	var new_tile = GameManager.getRandomUnoccupiedTile()
	currentTile.occupied = null
	currentTile = new_tile
	position = currentTile.position
	GameManager.occupyTile(currentTile, self)

func destroySelf():
	currentTile.occupied = null
	queue_free()
