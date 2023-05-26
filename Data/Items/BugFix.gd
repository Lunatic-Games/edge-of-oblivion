@tool
extends AnimationPlayer


func _ready() -> void:
	# HACK: Fixes an issue with the texture being resized when run from another scene.
	
	play("RESET")
