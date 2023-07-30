@icon("res://Assets/art/logic-tree/operations/i.png")
class_name LT_ClearItemArray
extends LogicTreeSetterOperation


@export var item_array: LT_ItemArrayVariable


func _ready() -> void:
	assert(item_array != null, "Item array not set for '" + name + "'")


func perform_behavior() -> void:
	item_array.value = []


func simulate_behavior() -> void:
	var current_val: Array[Item] = item_array.value
	perform_behavior()
	item_array.last_simulated_value = item_array.value
	item_array.value = current_val
