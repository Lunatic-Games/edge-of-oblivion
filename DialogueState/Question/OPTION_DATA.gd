class_name DialogueOptionData
extends Resource


@export var text: String = ""
# TODO: Make this of type DialogueState when it works (currently Godot doesn't like it)
@export var state_on_chosen: NodePath
