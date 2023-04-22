@icon("res://Assets/art/logic-tree/s.png")
class_name LogicTreeStringVariable
extends LogicTreeVariableBase

@export var default_value: String = ""
@export var default_value_override: LogicTreeStringVariable

var value: String = ""


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
