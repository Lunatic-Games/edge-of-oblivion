extends LogicTree


enum Comparison {
	Equals,
	DoesNotEqual
}

enum CompareTo {
	True,
	False
}

@export var input: LogicTreeBoolVariable
@export var comparison: Comparison
@export var value: CompareTo
@export var value_override: LogicTreeBoolVariable


func _ready() -> void:
	assert(input != null, "Input variable not set")


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
	
