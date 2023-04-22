@icon("res://Assets/art/logic-tree/variables/b.png")
class_name LT_BoolVariable
extends LT_VariableBaseClass

@export var default_value: bool = false
@export var default_value_override: LT_BoolVariable

var value: bool = false


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
