@icon("res://Assets/art/dialogue-state/question-mark.png")
class_name DS_IfLTBool
extends DialogueState


@export var bool_variable: LT_BoolVariable = null
@export var next_state_if_true: DialogueState = null
@export var next_state_if_false: DialogueState = null


func _ready() -> void:
	assert(bool_variable != null, "Bool variable is not specified for '" + name + "'")
	assert(next_state_if_true != null, "Next state if true is not specified for '" + name + "'")
	assert(next_state_if_false != null, "Next state if false is not specified for '" + name + "'")


func on_enter() -> void:
	if bool_variable.value == true:
		transition(next_state_if_true)
	else:
		transition(next_state_if_false)
