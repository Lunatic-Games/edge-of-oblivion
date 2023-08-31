class_name CharacterSelectMenu
extends CanvasLayer


signal faded_out

const GAME_SCENE: PackedScene = preload("res://Game/Game.tscn")


var displayed_item_data: ItemData = preload("res://Data/Items/Gladius/Gladius.tres")

var transitioning_out: bool = false

@onready var card: Card = $Sections/CharacterInfo/StartingInfoContainer/Card
@onready var transition_player: AnimationPlayer = $TransitionPlayer


func _ready() -> void:
	card.setup(displayed_item_data, 1, 1, false)


func fade_in():
	transition_player.play("fade_in")
	transitioning_out = false


func _on_back_button_pressed() -> void:
	if transitioning_out == true:
		return
	
	transitioning_out = true
	transition_player.play("fade_out")
	await transition_player.animation_finished
	faded_out.emit()


func _on_start_run_button_pressed() -> void:
	if transitioning_out == true:
		return
	
	transitioning_out = true
	transition_player.play("fade_to_black")
	await transition_player.animation_finished
	get_tree().change_scene_to_packed(GAME_SCENE)
