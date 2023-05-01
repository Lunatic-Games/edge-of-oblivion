@icon("res://Assets/art/logic-tree/operations/b.png")
class_name LT_SetBool
extends LogicTreeSetterOperation


@export var bool_variable: LT_BoolVariable
@export var value: bool = false
@export var value_override: LT_BoolVariable


func _ready() -> void:
	assert(bool_variable != null, "Bool variable not set for '" + name + "'")


func perform_behavior() -> void:
	if value_override != null:
		value = value_override.value
	
	bool_variable.value = value
