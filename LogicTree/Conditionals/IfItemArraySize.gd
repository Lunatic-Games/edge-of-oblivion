@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfItemArraySize
extends LogicTree


enum Comparison {
	GreaterThan,
	GreaterThanOrEqualTo,
	Equals,
	LessThanOrEqualTo,
	LessThan,
	DoesNotEqual
}

@export var input: LT_TileArrayVariable
@export var comparison: Comparison
@export var value: int = 0
@export var value_override: LT_IntVariable


func _ready() -> void:
	assert(input != null, "Input for '" + name + "' not set")


func evaluate_condition() -> bool:
	if value_override != null:
		value = value_override.value
	
	match comparison:
		Comparison.GreaterThan:
			return input.value.size() > value
		Comparison.GreaterThanOrEqualTo:
			return input.value.size() >= value
		Comparison.Equals:
			return input.value.size() == value
		Comparison.LessThanOrEqualTo:
			return input.value.size() <= value
		Comparison.LessThan:
			return input.value.size() < value
		Comparison.DoesNotEqual:
			return input.value.size() != value
	
	return false
