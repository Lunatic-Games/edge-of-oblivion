@icon("res://Assets/art/logic-tree/operations/i.png")
class_name LT_ClearItemArray
extends LogicTreeBasicVariableOperation


@export var item_array: LT_ItemArrayVariable


func _ready() -> void:
	assert(item_array != null, "Item array not set for '" + name + "'")


func perform_behavior() -> void:
	item_array.value = []
