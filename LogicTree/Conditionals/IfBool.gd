@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfBool
extends LogicTreeConditional


enum Comparison {
	EQUALS,
	DOES_NOT_EQUAL
}

enum CompareTo {
	TRUE,
	FALSE
}

@export var input: LT_BoolVariable
@export var comparison: Comparison
@export var value: CompareTo
@export var value_override: LT_BoolVariable


func _ready() -> void:
	assert(input != null, "Input not set for '" + name + "'")


func evaluate_condition() -> bool:
	if value_override != null:
		if value_override.value == true:
			value = CompareTo.TRUE
		else:
			value = CompareTo.FALSE
	
	if input.value == true and value == CompareTo.TRUE:
		return comparison == Comparison.EQUALS
	elif input.value == false and value == CompareTo.FALSE:
		return comparison == Comparison.EQUALS
	
	return comparison == Comparison.DOES_NOT_EQUAL
