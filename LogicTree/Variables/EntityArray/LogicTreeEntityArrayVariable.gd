@icon("res://Assets/art/logic-tree/e.png")
class_name LogicTreeEntityArrayVariable
extends LogicTreeVariableBase

@export var default_value: Array[Occupant] = []
@export var default_value_override: LogicTreeEntityArrayVariable

var value: Array[Occupant] = []


func reset_to_default() -> void:
	value.clear()
	
	if default_value_override != null:
		value.append_array(default_value_override.value)
	else:
		value.append_array(default_value)
