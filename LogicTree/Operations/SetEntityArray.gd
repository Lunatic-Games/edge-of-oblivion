@icon("res://Assets/art/logic-tree/operations/e.png")
class_name LT_SetEntityArray
extends LogicTreeOperation


enum Operation {
	SET,
	ADD
}

@export var entity_array: LT_EntityArrayVariable
@export var array_value: LT_EntityArrayVariable
@export var operation: Operation


func _ready() -> void:
	assert(entity_array != null, "Entity array not set for '" + name + "'")
	assert(array_value != null, "Array value not set for '" + name + "'")


func perform_behavior() -> void:
	if operation == Operation.ADD:
		entity_array.value.append_array(array_value.value)
		return
	
	if operation == Operation.SET:
		entity_array.value.clear()
		entity_array.value.append_array(array_value.value)
		return
