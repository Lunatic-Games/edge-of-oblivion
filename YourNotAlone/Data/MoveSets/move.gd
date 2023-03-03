extends Node2D


func indicate(starting_tile):
	for action in get_children():
		action.indicate(starting_tile)

func trigger(starting_tile):
	for action in get_children():
		action.trigger(starting_tile)
