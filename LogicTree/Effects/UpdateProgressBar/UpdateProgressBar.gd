extends LogicTree


@export var full_on_n: bool = true
@export var progress_bar: ProgressBar
@export var every_x_calls_node_for_value: EveryXCalls


func _ready() -> void:
	assert(progress_bar != null, "Progress bar not set")
	assert(every_x_calls_node_for_value != null, "Node not set")


func evaluate(targets: Array[Node]) -> bool:
	var times_evaluated: int = every_x_calls_node_for_value.times_evaluated
	var out_of: int = every_x_calls_node_for_value.n
	if full_on_n:
		out_of -= 1
	
	progress_bar.value = progress_bar.max_value * float(times_evaluated) / float(out_of)
	
	super.evaluate(targets)
	return true
