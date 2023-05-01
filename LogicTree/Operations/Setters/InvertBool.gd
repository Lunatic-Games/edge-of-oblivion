@icon("res://Assets/art/logic-tree/operations/toggle.png")
class_name LT_InvertBool
extends LogicTreeSetterOperation


@export var bool_variable: LT_BoolVariable


func _ready() -> void:
	assert(bool_variable != null, "Bool variable not set for '" + name + "'")


func perform_behavior() -> void:
	bool_variable.value = not bool_variable.value
