@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfBool
extends LogicTreeConditional


enum Comparison {
	Equals,
	DoesNotEqual
}

enum CompareTo {
	True,
	False
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
			value = CompareTo.True
		else:
			value = CompareTo.False
	
	if input.value == true and value == CompareTo.True:
		return comparison == Comparison.Equals
	elif input.value == false and value == CompareTo.False:
		return comparison == Comparison.Equals
	
	return value == CompareTo.False
