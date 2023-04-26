@icon("res://Assets/art/logic-tree/effects/reset.png")
class_name LT_ResetEveryXCalls
extends LogicTreeEffect

@export var every_x_calls: LT_EveryXCalls


func _ready() -> void:
	assert(every_x_calls != null, "EveryXCalls not set for '" + name + "'")


func perform_behavior() -> void:
	every_x_calls.times_evaluated = 0
