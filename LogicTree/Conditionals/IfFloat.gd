@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfFloat
extends LogicTreeConditional


enum Comparison {
	GREATER_THAN,
	GREATER_THAN_OR_EQUAL_TO,
	EQUALS,
	LESS_THAN_OR_EQUAL_TO,
	LESS_THAN,
	DOES_NOT_EQUAL
}

@export var input: LT_FloatVariable
@export var comparison: Comparison
@export var value: float = 0.0
@export var value_override: LT_FloatVariable


func _ready() -> void:
	assert(input != null, "Input not set for '" + name + "'")


func evaluate_condition() -> bool:
	if value_override != null:
		value = value_override.value
	
	var is_approx_equal: bool = is_equal_approx(input.value, value)
	
	match comparison:
		Comparison.GREATER_THAN:
			return is_approx_equal == false and input.value > value
		Comparison.GREATER_THAN_OR_EQUAL_TO:
			return input.value > value or is_approx_equal
		Comparison.EQUALS:
			return is_approx_equal
		Comparison.LESS_THAN_OR_EQUAL_TO:
			return input.value < value or is_approx_equal
		Comparison.LESS_THAN:
			return is_approx_equal == false and input.value < value
		Comparison.DOES_NOT_EQUAL:
			return is_approx_equal == false
	
	return false
