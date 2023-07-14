class_name MemoriesMenu
extends CanvasLayer


signal faded_out

@onready var transition_player: AnimationPlayer = $TransitionPlayer


func fade_in():
	transition_player.play("fade_in")


func _on_back_button_pressed() -> void:
	transition_player.play("fade_out")
	await transition_player.animation_finished
	faded_out.emit()
