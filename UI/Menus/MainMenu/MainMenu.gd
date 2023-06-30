extends Node

const GAME_SCENE: PackedScene = preload("res://Game/Game.tscn")

@onready var title: Control = $Title
@onready var menu_container: Control = $MenuContainer
@onready var quit_button: Button = $MenuContainer/QuitButton
@onready var credits_menu: CanvasLayer = $CreditsMenu
@onready var transition_player: AnimationPlayer = $TransitionAnimator


func _ready() -> void:
	if OS.has_feature("web"):
		quit_button.hide()  # Doesn't work in web browser
	
	transition_player.play("RESET")
	GlobalSignals.main_menu_entered.emit()


func set_menu_buttons_enabled(set_enabled: bool = true):
	for child in menu_container.get_children():
		var as_button: Button = child as Button
		if as_button:
			as_button.disabled = !set_enabled


func _on_PressAnything_anything_pressed() -> void:
	if transition_player.is_playing():
		return
	
	transition_player.play("anything_pressed")


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)


func _on_CreditsButton_pressed() -> void:
	transition_player.play("fade_out_menu")
	await transition_player.animation_finished
	credits_menu.fade_in()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_CreditsMenu_faded_out() -> void:
	transition_player.play("fade_in_menu")
