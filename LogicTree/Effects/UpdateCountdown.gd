@icon("res://Assets/art/logic-tree/effects/progress-bar.png")
class_name LT_UpdateCountdown
extends LogicTreeEffect


@export var countdown_label: Label
@export var every_x_calls: LT_EveryXCalls


func _ready() -> void:
	assert(countdown_label != null, "Countdown label not set for '" + name + "'")
	assert(every_x_calls != null, "LT_EveryXCalls not set for '" + name + "'")


func perform_behavior() -> void:
	var times_evaluated: int = every_x_calls.times_evaluated
	var out_of: int = every_x_calls.x
	var countdown: int = out_of - times_evaluated
	countdown_label.text = str(countdown)
