@icon("res://Assets/art/logic-tree/variables/n.png")
class_name LT_IntVariable
extends LogicTreeVariable


@export var default_value: int = 0
@export var default_value_override: LT_IntVariable

var value: int = 0


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
