extends "res://occupant.gd"

var currentTile

func _ready():
	occupantType = occupantTypes.collectable

func collect():
	# Grab a new random spawn location
	destroySelf()

func destroySelf():
	currentTile.occupied = null
	queue_free()
