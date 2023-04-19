extends LogicTree


enum Comparison {
	GreaterThan,
	GreaterThanOrEqualTo,
	Equals,
	LessThanOrEqualTo,
	LessThan,
	DoesNotEqual
}

@export var input: LogicTreeIntVariable
@export var comparison: Comparison
@export var value: int = 0
@export var value_override: LogicTreeIntVariable


func _ready() -> void:
	assert(input != null, "Input variable not set")


func evaluate_condition() -> bool:
	if value_override != null:
		value = value_override.value
	
	match comparison:
		Comparison.GreaterThan:
			return input.value > value
		Comparison.GreaterThanOrEqualTo:
			return input.value >= value
		Comparison.Equals:
			return input.value == value
		Comparison.LessThanOrEqualTo:
			return input.value <= value
		Comparison.LessThan:
			return input.value < value
		Comparison.DoesNotEqual:
			return input.value != value
	
	return false
