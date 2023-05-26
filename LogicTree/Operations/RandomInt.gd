@icon("res://Assets/art/logic-tree/operations/random.png")
class_name LT_RandomInt
extends LogicTreeOperation


enum Operation {
	SET,
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE_FLOOR,
	DIVIDE_CEILING
}

@export var int_variable: LT_IntVariable
@export var min_value: int = 1
@export var min_value_override: LT_IntVariable
@export var max_value: int = 6
@export var max_value_override: LT_IntVariable
@export var operation: Operation


func _ready() -> void:
	assert(int_variable != null, "Int variable not set for '" + name + "'")


func perform_behavior() -> void:
	if min_value_override != null:
		min_value = min_value_override.value
	
	if max_value_override != null:
		max_value = max_value_override.value
	
	assert(max_value >= min_value, "Max value smaller than minimum for '" + name + "'")
	
	var value: int = randi_range(min_value, max_value)
	
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
