class_name EveryXCalls
extends LogicTree


@export_range(1, 10, 1, "or_greater") var n = 1

var times_evaluated: int = 0
var met_condition: bool = false


func perform_behavior() -> void:
	times_evaluated += 1
	if times_evaluated >= n:
		met_condition = true
		times_evaluated = 0
	else:
		met_condition = false


func evaluate_condition() -> bool:
	return met_condition
