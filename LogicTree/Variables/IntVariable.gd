@icon("res://Assets/art/logic-tree/variables/n.png")
class_name LT_IntVariable
extends LogicTreeVariable


signal changed

@export var default_value: int = 0
@export var default_value_override: LT_IntVariable

var value: int = 0:
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
