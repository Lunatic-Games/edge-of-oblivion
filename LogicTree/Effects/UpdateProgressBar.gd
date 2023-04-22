extends LogicTree


@export var full_on_n: bool = true
@export var progress_bar: ProgressBar
@export var every_x_calls: LT_EveryXCalls


func _ready() -> void:
	assert(progress_bar != null, "Progress bar not set for '" + name + "'")
	assert(every_x_calls != null, "LT_EveryXCalls not set for '" + name + "'")


func perform_behavior() -> void:
	var times_evaluated: int = every_x_calls.times_evaluated
	var out_of: int = every_x_calls.x
	if every_x_calls.x_override != null:
		out_of = every_x_calls.x_override.value
	
	if full_on_n:
		out_of -= 1
	
	progress_bar.value = progress_bar.max_value * float(times_evaluated) / float(out_of)
