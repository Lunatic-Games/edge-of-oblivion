class_name VictoryMenu
extends CanvasLayer


const MAIN_MENU_SCENE: PackedScene = preload("res://Menus/MainMenu/MainMenu.tscn")

@onready var run_summary: RunSummary = $Container/Sections/RunSummary


func _on_PlayAgainButton_pressed() -> void:
	get_tree().reload_current_scene()


func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
