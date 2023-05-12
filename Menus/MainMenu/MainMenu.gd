extends Node

const GAME_SCENE: PackedScene = preload("res://GameScene/GameScene.tscn")

@onready var start_page: Control = $StartPage
@onready var credits_page: Control = $CreditsPage
@onready var transition_player: AnimationPlayer = $TransitionAnimator


func _ready() -> void:
	GlobalSignals.main_menu_entered.emit()


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)


func _on_CreditsButton_pressed() -> void:
	start_page.visible = false
	credits_page.visible = true


func _on_ReturnToStartPage_pressed() -> void:
	credits_page.visible = false
	start_page.visible = true


func _on_PressAnything_anything_pressed() -> void:
	if transition_player.is_playing():
		return
	
	transition_player.play("anything_pressed")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
