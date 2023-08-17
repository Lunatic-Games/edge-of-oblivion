@icon("res://Assets/art/dialogue-state/stop.png")
class_name DS_End
extends DialogueState


func on_enter():
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	if dialogue_overlay == null:
		return
	
	dialogue_overlay.close()
