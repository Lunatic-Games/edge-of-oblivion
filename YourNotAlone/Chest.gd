extends "res://occupant.gd"

var cardsToSpawn = 3
var currentTile

func _ready():
	occupantType = occupantTypes.collectable

func collect():
	print("Chest - Chest collected!")
	FreeUpgradeMenu.spawnUpgradeCards(cardsToSpawn)
	destroySelf()

func destroySelf():
	currentTile.occupied = null
	queue_free()
