@icon("res://Assets/art/logic-tree/operations/f.png")
class_name LT_SetFloat
extends LogicTreeSetterOperation


enum Operation {
	SET,
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

@export var float_variable: LT_FloatVariable
@export var value: float = 0.0
@export var value_override: LT_FloatVariable
@export var operation: Operation


func _ready() -> void:
	assert(float_variable != null, "Float variable not set for '" + name + "'")


func perform_behavior() -> void:
	if value_override != null:
		value = value_override.value
	
	match operation:
		Operation.SET:
			float_variable.value = value
		Operation.ADD:
			float_variable.value += value
		Operation.SUBTRACT:
			float_variable.value -= value
		Operation.MULTIPLY:
			float_variable.value *= value
		Operation.DIVIDE:
			assert(value != 0.0, "Trying to divide by zero for '" + name + "'")
			float_variable.value /= value


func simulate_behavior() -> void:
	var current_value: float = float_variable.value
	perform_behavior()
	float_variable.last_simulated_value = float_variable.value
	float_variable.value = current_value
