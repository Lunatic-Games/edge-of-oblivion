extends "res://occupant.gd"

var cardsToSpawn = 2
var currentTile

func _ready():
	occupantType = occupantTypes.collectable

func collect():
	FreeUpgradeMenu.spawnUpgradeCards(cardsToSpawn)
	destroySelf()

func destroySelf():
	currentTile.occupied = null
	queue_free()
