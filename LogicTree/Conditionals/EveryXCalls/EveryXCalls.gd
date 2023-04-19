class_name EveryXCalls
extends LogicTree


@export var x: LogicTreeIntVariable

var times_evaluated: int = 0
var met_condition: bool = false


func _ready() -> void:
	assert(x != null, "X variable not set")


func perform_behavior() -> void:
	times_evaluated += 1
	if times_evaluated >= x.value:
		met_condition = true
		times_evaluated = 0
	else:
		met_condition = false


func evaluate_condition() -> bool:
	return met_condition
