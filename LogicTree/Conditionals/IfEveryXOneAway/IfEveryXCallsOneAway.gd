extends LogicTree


@export var every_x_calls_node: EveryXCalls


func evaluate(targets: Array[Node]) -> bool:
	var times_evaluated: int = every_x_calls_node.times_evaluated
	var out_of: int = every_x_calls_node.n
	
	if times_evaluated == out_of - 1:
		super.evaluate(targets)
		return true
	
	return false
