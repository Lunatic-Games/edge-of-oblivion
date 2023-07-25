@icon("res://Assets/art/logic-tree/logic-tree.png")
class_name LogicTree
extends Node


signal evaluated

@export var invert_recurse_condition: bool = false
@export_range(0, 1000, 1, "or_greater") var async_wait_before_recurse_ms: float


# Should not be overriden
func evaluate() -> void:
	perform_behavior()
	
	# Don't continue if false and not inverted, or if true and inverted
	if evaluate_condition() == invert_recurse_condition:
		evaluated.emit()
		return
	
	if async_wait_before_recurse_ms > 0:
		await get_tree().create_timer(async_wait_before_recurse_ms / 1000.0).timeout
	
	evaluate_child_trees()
	evaluated.emit()


# Should not be overriden except for special cases
func evaluate_child_trees() -> void:
	for child in get_children():
		var sub_tree = child as LogicTree
		if sub_tree:
			sub_tree.evaluate()


# Can be overriden to define new behavior
func perform_behavior() -> void:
	pass


# Can be overriden to make children evaluation to only occur in certain conditions
func evaluate_condition() -> bool:
	return true
