extends Node2D


func _ready():
	TurnManager.connect("playerTurnEnded", self, "destroySelf")

func destroySelf():
	queue_free()
