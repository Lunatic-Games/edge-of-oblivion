extends Node

const GAME_SCENE: PackedScene = preload("res://GameScene/GameScene.tscn")

@onready var title: Control = $Title
@onready var start_page: Control = $StartPage
@onready var credits_page: Control = $CreditsPage
@onready var transition_player: AnimationPlayer = $TransitionAnimator


func _ready() -> void:
	GlobalSignals.main_menu_entered.emit()


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)


func _on_CreditsButton_pressed() -> void:
	title.hide()
	start_page.hide()
	credits_page.show()


func _on_ReturnToStartPage_pressed() -> void:
	credits_page.hide()
	start_page.show()


func _on_PressAnything_anything_pressed() -> void:
	if transition_player.is_playing():
		return
	
	transition_player.play("anything_pressed")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_return_to_main_menu_button_pressed() -> void:
	credits_page.hide()
	title.show()
	start_page.show()
