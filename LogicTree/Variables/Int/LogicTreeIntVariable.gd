@icon("res://Assets/art/logic-tree/n.png")
class_name LogicTreeIntVariable
extends LogicTreeVariableBase

@export var default_value: int = 0
@export var default_value_override: LogicTreeIntVariable

var value: int = 0


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
