@icon("res://Assets/art/logic-tree/operations/f.png")
class_name LT_SetFloat
extends LogicTreeBasicVariableOperation


enum Operation {
	Set,
	Add,
	Subtract,
	Multiply,
	Divide
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
		Operation.Set:
			float_variable.value = value
		Operation.Add:
			float_variable.value += value
		Operation.Subtract:
			float_variable.value -= value
		Operation.Multiply:
			float_variable.value *= value
		Operation.Divide:
			assert(value != 0.0, "Trying to divide by zero for '" + name + "'")
			float_variable.value /= value
