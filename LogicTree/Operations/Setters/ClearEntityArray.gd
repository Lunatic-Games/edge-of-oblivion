@icon("res://Assets/art/logic-tree/operations/e.png")
class_name LT_ClearEntityArray
extends LogicTreeSetterOperation


@export var entity_array: LT_EntityArrayVariable


func _ready() -> void:
	assert(entity_array != null, "Entity array not set for '" + name + "'")


func perform_behavior() -> void:
	entity_array.value = []


func simulate_behavior() -> void:
	var current_value: Array[Occupant] = entity_array.value
	perform_behavior()
	entity_array.last_simulated_value = entity_array.value
	entity_array.value = current_value
