extends "res://Data/Units/Enemies/Enemy.gd"

func _ready():
	._ready()
	targetTiles = [currentTile.topTile, currentTile.bottomTile, currentTile.leftTile, currentTile.rightTile]
