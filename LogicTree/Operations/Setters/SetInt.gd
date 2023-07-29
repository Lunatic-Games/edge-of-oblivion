@icon("res://Assets/art/logic-tree/operations/n.png")
class_name LT_SetInt
extends LogicTreeSetterOperation


enum Operation {
	SET,
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE_FLOOR,
	DIVIDE_CEILING
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
		Operation.SET:
			int_variable.value = value
		Operation.ADD:
			int_variable.value += value
		Operation.SUBTRACT:
			int_variable.value -= value
		Operation.MULTIPLY:
			int_variable.value *= value
		Operation.DIVIDE_FLOOR:
			assert(value != 0.0, "Trying to divide by zero for '" + name + "'")
			var value_as_float := float(value)
			var current_value_as_float := float(int_variable.value)
			int_variable.value = floori(current_value_as_float / value_as_float)
		Operation.DIVIDE_CEILING:
			assert(value != 0.0, "Trying to divide by zero for '" + name + "'")
			var value_as_float := float(value)
			var current_value_as_float := float(int_variable.value)
			int_variable.value = ceili(current_value_as_float / value_as_float)


func simulate_behavior() -> void:
	var current_val: int = int_variable.value
	perform_behavior()
	int_variable.last_simulated_value = int_variable.value
	int_variable.value = current_val
