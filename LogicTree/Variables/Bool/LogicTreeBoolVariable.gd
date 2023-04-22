@icon("res://Assets/art/logic-tree/b.png")
class_name LogicTreeBoolVariable
extends LogicTreeVariableBase

@export var default_value: bool = false
@export var default_value_override: LogicTreeBoolVariable

var value: bool = false


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
