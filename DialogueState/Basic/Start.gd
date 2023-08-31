@icon("res://Assets/art/dialogue-state/start.png")
class_name DS_Start
extends DialogueState


@export var start_state: DialogueState = null


func on_enter():
	if start_state == null:
		return
	
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	if dialogue_overlay == null:
		return
	
	dialogue_overlay.open()
	transition(start_state)
