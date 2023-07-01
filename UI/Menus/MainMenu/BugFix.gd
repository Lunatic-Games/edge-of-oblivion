@tool
extends AnimationPlayer


func _ready() -> void:
	# HACK: Because for some reason various control nodes are getting incorrectly sized when
	# MainMenu.tscn is run from another scene.
	# RESET Animation is set to fix the incorrect sizing, so this is just calling that on opening
	# the scene in the editor (@tool) or running the scene in-game.
	if Engine.is_editor_hint():
		play("RESET")
	else:
		play("fade_from_black")
