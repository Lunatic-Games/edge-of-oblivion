@icon("res://Assets/art/logic-tree/variables/f.png")
class_name LT_FloatVariable
extends LogicTreeVariable


@export var default_value: float = 0.0
@export var default_value_override: LT_FloatVariable

var value: float = 0.0


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
