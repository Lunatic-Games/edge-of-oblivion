@icon("res://Assets/art/logic-tree/conditionals/random.png")
class_name LT_IfRandom
extends LogicTreeConditional


@export_range(1, 100, 1, "or_greater") var one_out_of: int
@export var one_out_of_override: LT_IntVariable


func _ready() -> void:
	randomize()


func evaluate_condition() -> bool:
	if one_out_of_override != null:
		one_out_of = one_out_of_override.value
	
	assert(one_out_of >= 1, "One-out-of value set to below one for '" + name + "'")
	
	var value: int = randi_range(1, one_out_of)
	return value == 1
