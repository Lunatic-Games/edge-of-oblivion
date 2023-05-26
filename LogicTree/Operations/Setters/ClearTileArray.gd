@icon("res://Assets/art/logic-tree/operations/t.png")
class_name LT_ClearTileArray
extends LogicTreeSetterOperation


@export var tile_array: LT_TileArrayVariable


func _ready() -> void:
	assert(tile_array != null, "Tile array not set for '" + name + "'")


func perform_behavior() -> void:
	tile_array.value = []
