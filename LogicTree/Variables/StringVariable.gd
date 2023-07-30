@icon("res://Assets/art/logic-tree/variables/s.png")
class_name LT_StringVariable
extends LogicTreeVariable


signal changed

@export var default_value: String = ""
@export var default_value_override: LT_StringVariable
var last_simulated_value: String = ""

var value: String = "":
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
