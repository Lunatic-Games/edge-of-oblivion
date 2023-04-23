@icon("res://Assets/art/logic-tree/conditionals/if-n.png")
class_name LT_EveryXCalls
extends LogicTreeConditional


@export_range(0, 100, 1, "or_greater") var x: int
@export var x_override: LT_IntVariable
@export var on_one_before: bool = false

var times_evaluated: int = 0
var met_condition: bool = false


func perform_behavior() -> void:
	if x_override != null:
		x = x_override.value
	
	times_evaluated += 1
	if on_one_before and times_evaluated >= x - 1:
		met_condition = true
	elif times_evaluated >= x:
		met_condition = true
	else:
		met_condition = false
	
	if times_evaluated >= x:
		times_evaluated = 0


func evaluate_condition() -> bool:
	return met_condition
