@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfInt
extends LogicTreeConditional


enum Comparison {
	GreaterThan,
	GreaterThanOrEqualTo,
	Equals,
	LessThanOrEqualTo,
	LessThan,
	DoesNotEqual
}

@export var input: LT_IntVariable
@export var comparison: Comparison
@export var value: int = 0
@export var value_override: LT_IntVariable


func _ready() -> void:
	assert(input != null, "Input not set for '" + name + "'")


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
