class_name EveryXCalls
extends LogicTree


@export_range(1, 10, 1, "or_greater") var n = 1

var times_evaluated: int = 0


func evaluate(targets: Array[Node]) -> bool:
	times_evaluated += 1
	
	if times_evaluated >= n:
		super.evaluate(targets)
		times_evaluated = 0
		return true
	
	return false
