@icon("res://Assets/art/logic-tree/variables/i.png")
class_name LT_ItemArrayVariable
extends LogicTreeVariable

@export var default_value: Array[Item] = []
@export var default_value_override: LT_ItemArrayVariable

var value: Array[Item] = []


func reset_to_default() -> void:
	value.clear()
	
	if default_value_override != null:
		value.append_array(default_value_override.value)
	else:
		value.append_array(default_value)
