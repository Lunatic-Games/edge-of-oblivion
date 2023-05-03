@icon("res://Assets/art/logic-tree/variables/t.png")
class_name LT_TileArrayVariable
extends LogicTreeVariable


@export var default_value: Array[Tile] = []
@export var default_value_override: LT_TileArrayVariable

var value: Array[Tile] = []


func reset_to_default() -> void:
	value.clear()
	
	if default_value_override != null:
		value.append_array(default_value_override.value)
	else:
		value.append_array(default_value)
