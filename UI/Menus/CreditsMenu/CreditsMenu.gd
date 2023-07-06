extends CanvasLayer


signal faded_out

@onready var transition_player = $TransitionPlayer


func fade_in():
	transition_player.play("fade_in")


func _on_return_to_main_menu_button_pressed() -> void:
	transition_player.play("fade_out")
	await transition_player.animation_finished
	
	hide()
	faded_out.emit()
