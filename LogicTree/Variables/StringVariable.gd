@icon("res://Assets/art/logic-tree/variables/s.png")
class_name LT_StringVariable
extends LogicTreeVariable


@export var default_value: String = ""
@export var default_value_override: LT_StringVariable

var value: String = ""


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
