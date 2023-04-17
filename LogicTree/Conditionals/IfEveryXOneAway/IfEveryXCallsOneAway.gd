extends LogicTree


@export var every_x_calls: EveryXCalls


func evaluate_condition() -> bool:
	var times_evaluated: int = every_x_calls.times_evaluated
	var out_of: int = every_x_calls.n
	
	return times_evaluated == out_of - 1
