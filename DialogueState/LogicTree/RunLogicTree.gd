@icon("res://Assets/art/dialogue-state/logic-tree.png")
class_name DS_RunLogicTree
extends DialogueState


@export var logic_tree: LogicTree = null
@export var next_state: DialogueState = null


func _ready() -> void:
	assert(logic_tree != null, "Logic tree is not specified for '" + name + "'")
	assert(next_state != null, "Next state is not specified for '" + name + "'")


func on_enter() -> void:
	logic_tree.evaluate()
	transition(next_state)
