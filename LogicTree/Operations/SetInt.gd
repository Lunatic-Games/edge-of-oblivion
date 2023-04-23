@icon("res://Assets/art/logic-tree/operations/n.png")
class_name LT_SetInt
extends LogicTreeOperation


@export var int_variable: LT_IntVariable
@export var value: int = 0


func _ready() -> void:
	assert(int_variable != null, "Int variable not set for '" + name + "'")


func perform_behavior() -> void:
	int_variable.value = value
