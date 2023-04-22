@icon("res://Assets/art/logic-tree/i.png")
class_name LogicTreeItemArrayVariable
extends LogicTreeVariableBase

@export var default_value: Array[Item] = []
@export var default_value_override: LogicTreeItemArrayVariable

var value: Array[Item] = []


func reset_to_default() -> void:
	value.clear()
	
	if default_value_override != null:
		value.append_array(default_value_override.value)
	else:
		value.append_array(default_value)
