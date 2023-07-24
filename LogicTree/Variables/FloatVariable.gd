@icon("res://Assets/art/logic-tree/variables/f.png")
class_name LT_FloatVariable
extends LogicTreeVariable


signal changed

@export var default_value: float = 0.0
@export var default_value_override: LT_FloatVariable

var value: float = 0.0:
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
