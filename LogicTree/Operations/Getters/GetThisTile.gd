@icon("res://Assets/art/logic-tree/operations/t.png")
class_name LT_GetThisTile
extends LogicTreeGetterOperation


@export var output_tile: LT_TileArrayVariable
@export var output_occupant: LT_EntityArrayVariable


func perform_behavior() -> void:
	var this_tile: Tile = owner as Tile
	assert(this_tile != null,
			"Trying to get 'this tile' for '" + name + "'but 'this tile' is not a tile")
	
	if output_occupant != null:
		output_tile.value = [this_tile]
	
	if output_occupant != null:
		if this_tile.occupant != null:
			output_occupant.value = [this_tile.occupant]
		else:
			output_occupant.value.clear()
