@icon("res://Assets/art/logic-tree/conditionals/repeat.png")
class_name LT_WhileBool
extends LogicTreeConditional


@export var input: LT_BoolVariable


func _ready() -> void:
	assert(input != null, "Input not set for '" + name + "'")


func evaluate_child_trees() -> void:
	super.evaluate_child_trees()
	evaluate()  # Will cause tree to loop until condition is false


func evaluate_condition() -> bool:
	return input.value == true
