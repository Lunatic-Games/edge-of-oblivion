@icon("res://Assets/art/logic-tree/t.png")
class_name LogicTreeTileArrayVariable
extends LogicTreeVariableBase

@export var default_value: Array[Tile] = []
@export var default_value_override: LogicTreeTileArrayVariable

var value: Array[Tile] = []


func reset_to_default() -> void:
	value.clear()
	
	if default_value_override != null:
		value.append_array(default_value_override.value)
	else:
		value.append_array(default_value)
