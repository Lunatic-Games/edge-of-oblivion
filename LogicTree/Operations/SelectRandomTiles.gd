@icon("res://Assets/art/logic-tree/operations/random.png")
class_name LT_SelectRandomTiles
extends LogicTreeOperation


@export var input_tiles: LT_TileArrayVariable
@export var output_tiles: LT_TileArrayVariable
@export_range(1, 10, 1, "or_greater") var n_selections: int = 1
@export var n_selections_override: LT_IntVariable
@export var must_be_unique: bool = true


func _ready() -> void:
	assert(input_tiles != null, "Input tiles not set for '" + name + "'")
	assert(output_tiles != null, "Output tiles not set for '" + name + "'")
	randomize()


func perform_behavior() -> void:
	if n_selections_override != null:
		n_selections = n_selections_override.value
	
	var picked_tiles: Array[Tile] = []
	var tiles_to_pick_from: Array[Tile] = []
	tiles_to_pick_from.append_array(input_tiles.value)
	
	for i in n_selections:
		if tiles_to_pick_from.is_empty():
			break
		
		var tile_i = randi() % tiles_to_pick_from.size()
		picked_tiles.append(tiles_to_pick_from[tile_i])
		if must_be_unique:
			tiles_to_pick_from.remove_at(tile_i)
	
	output_tiles.value = picked_tiles
