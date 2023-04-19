extends LogicTree


@export var full_on_n: bool = true
@export var progress_bar: ProgressBar
@export var every_x_calls: EveryXCalls


func _ready() -> void:
	assert(progress_bar != null, "Progress bar not set")
	assert(every_x_calls != null, "EveryXCalls not set")


func perform_behavior() -> void:
	var times_evaluated: int = every_x_calls.times_evaluated
	var out_of: int = every_x_calls.x.value
	if full_on_n:
		out_of -= 1
	
	progress_bar.value = progress_bar.max_value * float(times_evaluated) / float(out_of)
