@icon("res://Assets/art/logic-tree/variables/i.png")
class_name LT_ItemArrayVariable
extends LogicTreeVariable


signal changed

@export var default_value: Array[Item] = []
@export var default_value_override: LT_ItemArrayVariable
var last_simulated_value: Array[Item] = []

var value: Array[Item] = []:
	set(new_value):
		var is_new_value: bool = new_value != value
		value = new_value
		if is_new_value:
			changed.emit()


func reset_to_default() -> void:
	value.clear()
	
	if default_value_override != null:
		value.append_array(default_value_override.value)
	else:
		value.append_array(default_value)
