@icon("res://Assets/art/logic-tree/conditionals/if-n.png")
class_name LT_EveryXCalls
extends LogicTreeConditional


@export_range(1, 100, 1, "or_greater") var x: int = 1
@export var x_override: LT_IntVariable
@export var on_one_before: bool = false

var times_evaluated: int = 0
var met_condition: bool = false


func refresh() -> void:
	if x_override != null:
		x = x_override.value


func is_one_before() -> bool:
	return times_evaluated == x - 1


func perform_behavior() -> void:
	refresh()
	
	times_evaluated += 1
	if on_one_before and times_evaluated == x - 1:
		met_condition = true
	elif on_one_before == false and times_evaluated >= x:
		met_condition = true
	else:
		met_condition = false
	
	while times_evaluated >= x:
		times_evaluated -= x


func evaluate_condition() -> bool:
	return met_condition
