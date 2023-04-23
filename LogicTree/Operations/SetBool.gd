@icon("res://Assets/art/logic-tree/operations/b.png")
class_name LT_SetBool
extends LogicTreeOperation


@export var bool_variable: LT_BoolVariable
@export var value: bool = false


func _ready() -> void:
	assert(bool_variable != null, "Bool variable not set for '" + name + "'")


func perform_behavior() -> void:
	bool_variable.value = value
