@icon("res://Assets/art/logic-tree/operations/n.png")
class_name LT_SetInt
extends LogicTreeOperation

enum Operation {
	Set,
	Add,
	Subtract,
	Multiply,
	DivideFloor,
	DivideCeiling
}

@export var int_variable: LT_IntVariable
@export var value: int = 0
@export var value_override: LT_IntVariable
@export var operation: Operation


func _ready() -> void:
	assert(int_variable != null, "Int variable not set for '" + name + "'")


func perform_behavior() -> void:
	if value_override != null:
		value = value_override.value
	
	match operation:
		Operation.Set:
			int_variable.value = value
		Operation.Add:
			int_variable.value += value
		Operation.Subtract:
			int_variable.value -= value
		Operation.Multiply:
			int_variable.value *= value
		Operation.DivideFloor:
			assert(value != 0.0, "Trying to divide by zero for '" + name + "'")
			var value_as_float := float(value)
			var current_value_as_float := float(int_variable.value)
			int_variable.value = floori(current_value_as_float / value_as_float)
		Operation.DivideCeiling:
			assert(value != 0.0, "Trying to divide by zero for '" + name + "'")
			var value_as_float := float(value)
			var current_value_as_float := float(int_variable.value)
			int_variable.value = ceili(current_value_as_float / value_as_float)
