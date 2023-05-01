@icon("res://Assets/art/logic-tree/operations/i.png")
class_name LT_SetItemArray
extends LogicTreeSetterOperation


enum Operation {
	SET,
	ADD
}

@export var item_array: LT_ItemArrayVariable
@export var array_value: LT_ItemArrayVariable
@export var operation: Operation


func _ready() -> void:
	assert(item_array != null, "Item array not set for '" + name + "'")
	assert(array_value != null, "Array value not set for '" + name + "'")


func perform_behavior() -> void:
	if operation == Operation.ADD:
		item_array.value.append_array(array_value.value)
		return
	
	if operation == Operation.SET:
		item_array.value.clear()
		item_array.value.append_array(array_value.value)
		return
