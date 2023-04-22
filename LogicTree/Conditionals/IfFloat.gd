@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfFloat
extends LogicTree


enum Comparison {
	GreaterThan,
	GreaterThanOrEqualTo,
	Equals,
	LessThanOrEqualTo,
	LessThan,
	DoesNotEqual
}

@export var input: LT_FloatVariable
@export var comparison: Comparison
@export var value: float = 0.0
@export var value_override: LT_FloatVariable


func _ready() -> void:
	assert(input != null, "Input for '" + name + "' not set")


func evaluate_condition() -> bool:
	if value_override != null:
		value = value_override.value
	
	var is_approx_equal: bool = is_equal_approx(input.value, value)
	
	match comparison:
		Comparison.GreaterThan:
			return is_approx_equal == false and input.value > value
		Comparison.GreaterThanOrEqualTo:
			return input.value > value or is_approx_equal
		Comparison.Equals:
			return is_approx_equal
		Comparison.LessThanOrEqualTo:
			return input.value < value or is_approx_equal
		Comparison.LessThan:
			return is_approx_equal == false and input.value < value
		Comparison.DoesNotEqual:
			return is_approx_equal == false
	
	return false
