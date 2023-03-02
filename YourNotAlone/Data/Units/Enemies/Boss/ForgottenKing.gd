extends "res://Data/Units/Enemies/Boss/Boss.gd"

func choose_moveset():
	if move_sets.size() > 1:
		if currentTile.is_tile_n_tiles_away(GameManager.player.currentTile, 1):
			chosen_move = move_sets[1]
			chosen_move.indicate(currentTile)
		else:
			chosen_move = move_sets[0]
			chosen_move.indicate(currentTile)
