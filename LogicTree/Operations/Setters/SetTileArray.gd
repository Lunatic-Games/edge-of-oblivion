@icon("res://Assets/art/logic-tree/operations/t.png")
class_name LT_SetTileArray
extends LogicTreeSetterOperation


enum Operation {
	SET,
	ADD
}

@export var tile_array: LT_TileArrayVariable
@export var array_value: LT_TileArrayVariable
@export var operation: Operation


func _ready() -> void:
	assert(tile_array != null, "Tile array not set for '" + name + "'")
	assert(array_value != null, "Array value not set for '" + name + "'")


func perform_behavior() -> void:
	if operation == Operation.ADD:
		tile_array.value.append_array(array_value.value)
		return
	
	if operation == Operation.SET:
		tile_array.value.clear()
		tile_array.value.append_array(array_value.value)
		return


func simulate_behavior() -> void:
	var current_val: Array[Tile] = tile_array.value
	perform_behavior()
	tile_array.last_simulated_value = tile_array.value
	tile_array.value = current_val
