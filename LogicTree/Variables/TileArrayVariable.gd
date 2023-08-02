@icon("res://Assets/art/logic-tree/variables/t.png")
class_name LT_TileArrayVariable
extends LogicTreeVariable


signal changed

@export var default_value: Array[Tile] = []
@export var default_value_override: LT_TileArrayVariable

var last_simulated_value: Array[Tile] = []

var value: Array[Tile] = []:
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
	last_simulated_value = value.duplicate()
