@icon("res://Assets/art/logic-tree/f.png")
class_name LogicTreeFloatVariable
extends LogicTreeVariableBase

@export var default_value: float = 0.0
@export var default_value_override: LogicTreeFloatVariable

var value: float = 0.0


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
