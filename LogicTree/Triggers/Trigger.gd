@icon("res://Assets/art/logic-tree/triggers/t.png")
class_name LogicTreeTrigger
extends Node


@export var logic_tree_on_trigger: LogicTree


func _ready() -> void:
	assert(logic_tree_on_trigger != null, "LogicTree not set for '" + name + "'")
