class_name LogicTree
extends Node


var last_evaluation: bool = false


func evaluate(targets: Array[Node]) -> bool:
	for child in get_children():
		var sub_tree = child as LogicTree
		if sub_tree:
			last_evaluation = sub_tree.evaluate(targets)
	
	return true
