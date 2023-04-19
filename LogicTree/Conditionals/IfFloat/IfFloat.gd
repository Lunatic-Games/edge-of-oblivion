extends LogicTree


enum Comparison {
	GreaterThan,
	GreaterThanOrEqualTo,
	Equals,
	LessThanOrEqualTo,
	LessThan,
	DoesNotEqual
}

@export var input: LogicTreeFloatVariable
@export var comparison: Comparison
@export var value: float = 0.0
@export var value_override: LogicTreeFloatVariable


func _ready() -> void:
	assert(input != null, "Input variable not set")


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
