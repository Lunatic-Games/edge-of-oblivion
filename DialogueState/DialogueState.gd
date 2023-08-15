@icon("res://Assets/art/dialogue-state/speech.png")
class_name DialogueState
extends Node


func transition(to: DialogueState) -> void:
	if to == self:
		return
	
	on_exit()
	to.on_enter()


func on_enter():
	pass


func on_exit():
	pass
