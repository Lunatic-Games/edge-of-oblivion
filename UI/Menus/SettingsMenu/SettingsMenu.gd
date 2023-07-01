extends CanvasLayer


signal faded_out

@onready var transition_player: AnimationPlayer = $TransitionPlayer


func fade_in():
	transition_player.play("fade_in")


func _on_ConfirmButton_pressed() -> void:
	Saving.save_user_settings_to_file()
	transition_player.play("fade_out")
	await transition_player.animation_finished
	faded_out.emit()
