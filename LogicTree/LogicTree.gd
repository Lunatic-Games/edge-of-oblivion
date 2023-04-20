class_name LogicTree
extends Node


@export var invert_recurse_condition: bool = false
@export_range(0, 1000, 1, "or_greater") var async_wait_before_recurse_ms: float


# Should not be overriden
func evaluate() -> void:
	perform_behavior()
	
	# Don't continue if false and not inverted, or if true and inverted
	if evaluate_condition() == invert_recurse_condition:
		return
	
	if async_wait_before_recurse_ms > 0:
		await get_tree().create_timer(async_wait_before_recurse_ms / 1000.0).timeout
	
	for child in get_children():
		var sub_tree = child as LogicTree
		if sub_tree:
			sub_tree.evaluate()
		else:
			try_resetting_variable(child)


# Can be overriden to define new behavior
func perform_behavior() -> void:
	pass


# Can be overriden to make children evaluation to only occur in certain conditions
func evaluate_condition() -> bool:
	return true


func try_resetting_variable(node: Node) -> void:
	var bool_var := node as LogicTreeBoolVariable
	if bool_var != null:
		bool_var.reset_to_default()
		return
	
	var int_var : = node as LogicTreeIntVariable
	if int_var != null:
		int_var.reset_to_default()
		return
	
	var float_var := node as LogicTreeFloatVariable
	if float_var != null:
		float_var.reset_to_default()
		return
	
	var tile_array_var := node as LogicTreeTileArrayVariable
	if tile_array_var != null:
		tile_array_var.reset_to_default()
		return
	
	var entity_array_var := node as LogicTreeEntityArrayVariable
	if entity_array_var != null:
		entity_array_var.reset_to_default()
		return
	
	var item_array_var := node as LogicTreeItemArrayVariable
	if item_array_var != null:
		item_array_var.reset_to_default()
		return
