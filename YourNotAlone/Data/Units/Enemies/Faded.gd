extends "res://Data/Units/Enemies/Enemy.gd"

func _ready():
	._ready()

func choose_moveset():
	if move_sets.size() > 0:
		chosen_move = move_sets[0]
		chosen_move.indicate(currentTile)