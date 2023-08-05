@icon("res://Assets/art/logic-tree/variables/b.png")
class_name LT_BoolVariable
extends LogicTreeVariable


signal changed

@export var default_value: bool = false
@export var default_value_override: LT_BoolVariable

var last_simulated_value: bool = false

var value: bool = false:
	set(new_value):
		var is_new_value: bool = new_value != value
		value = new_value
		if is_new_value:
			changed.emit()


func reset_to_default() -> void:
	if default_value_override != null:
		value = default_value_override.value
	else:
		value = default_value
	last_simulated_value = value
