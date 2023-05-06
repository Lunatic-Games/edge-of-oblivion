extends Control


signal anything_pressed

const SECRET_STRING: String = "cutie"

var progress_string: String = ""

@onready var animator: AnimationPlayer = $"../Background/Animators/BlushAnimator"


func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventKey and event.is_pressed():
		var character: String = OS.get_keycode_string(event.keycode).to_lower()
		var current_progress_i: int = progress_string.length()
		if SECRET_STRING[current_progress_i].to_lower() == character:
			progress_string += character
			if progress_string == SECRET_STRING:
				progress_string = ""
				animator.play("blush_on_and_off")
			return
		else:
			progress_string = ""
	
	if event is InputEventMouseButton and event.is_pressed():
		anything_pressed.emit()
