class_name PauseMenu
extends CanvasLayer


const MAIN_MENU_SCENE: PackedScene = preload("res://UI/Menus/MainMenu/MainMenu.tscn")

@onready var menu_container = $Background/MenuContainer
@onready var confirm_container = $Background/ConfirmMainMenu/ButtonContainer
@onready var settings_menu = $Background/SettingsMenu
@onready var transition_player = $TransitionPlayer


func _unhandled_input(event: InputEvent) -> void:
	if transition_player.is_playing() or settings_menu.visible:
		return
	
	if visible and event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		transition_player.play("fade_out")
		await transition_player.animation_finished
		get_tree().paused = false


func pause_and_fade_in():
	get_tree().paused = true
	transition_player.play("fade_in")


func set_menu_buttons_enabled(set_enabled: bool = true):
	for child in menu_container.get_children():
		var as_button: Button = child as Button
		if as_button:
			as_button.disabled = !set_enabled


func set_confirm_buttons_enabled(set_enabled: bool = true):
	for child in confirm_container.get_children():
		var as_button: Button = child as Button
		if as_button:
			as_button.disabled = !set_enabled


func _on_continue_button_pressed() -> void:
	transition_player.play("fade_out")
	await transition_player.animation_finished
	get_tree().paused = false


func _on_settings_button_pressed() -> void:
	transition_player.play("fade_out_menu_container")
	await transition_player.animation_finished
	settings_menu.fade_in()


func _on_main_menu_button_pressed() -> void:
	transition_player.play("fade_out_menu_container")
	await transition_player.animation_finished
	transition_player.play("fade_in_confirm_menu")


func _on_main_menu_cancel_button_pressed() -> void:
	transition_player.play("fade_out_confirm_menu")
	await transition_player.animation_finished
	transition_player.play("fade_in_menu_container")


func _on_main_menu_confirm_button_pressed() -> void:
	transition_player.play("fade_to_black")
	await transition_player.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)


func _on_settings_menu_faded_out() -> void:
	transition_player.play("fade_in_menu_container")
