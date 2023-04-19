extends LogicTree


@export var every_x_calls: EveryXCalls


func _ready() -> void:
	assert(every_x_calls != null, "EveryXCalls variable not set")


func evaluate_condition() -> bool:
	var times_evaluated: int = every_x_calls.times_evaluated
	var out_of: int = every_x_calls.x.value
	
	return times_evaluated == out_of - 1
