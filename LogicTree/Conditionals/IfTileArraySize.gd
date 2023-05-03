@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfTileArraySize
extends LogicTreeConditional


enum Comparison {
	GREATER_THAN,
	GREATER_THAN_OR_EQUAL_TO,
	EQUALS,
	LESS_THAN_OR_EQUAL_TO,
	LESS_THAN,
	DOES_NOT_EQUAL
}

@export var input: LT_TileArrayVariable
@export var comparison: Comparison
@export var value: int = 0
@export var value_override: LT_IntVariable


func _ready() -> void:
	assert(input != null, "Input not set for '" + name + "'")


func evaluate_condition() -> bool:
	if value_override != null:
		value = value_override.value
	
	match comparison:
		Comparison.GREATER_THAN:
			return input.value.size() > value
		Comparison.GREATER_THAN_OR_EQUAL_TO:
			return input.value.size() >= value
		Comparison.EQUALS:
			return input.value.size() == value
		Comparison.LESS_THAN_OR_EQUAL_TO:
			return input.value.size() <= value
		Comparison.LESS_THAN:
			return input.value.size() < value
		Comparison.DOES_NOT_EQUAL:
			return input.value.size() != value
	
	return false
