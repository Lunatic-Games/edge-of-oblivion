class_name GameScene
extends Node2D

@onready var board: Board = $Board
@onready var victory_menu: Control = $Menus/VictoryPanel
@onready var game_over_menu: Control = $Menus/GameOver


func _ready() -> void:
	GameManager.start_game()
	TurnManager.initialize()
	
	GlobalSignals.player_died.connect(_on_Player_died)  # Game over!
	GlobalSignals.boss_defeated.connect(_on_Boss_defeated)  # Game won!


func _return_to_main_menu() -> void:
	GameManager.change_to_main_menu()
	GameManager.stop_game()
	get_tree().paused = false


func _on_Player_died(_player: Player) -> void:
	await get_tree().create_timer(1.0).timeout
	
	FreeUpgradeMenu.force_hide_display()
	get_tree().paused = true
	game_over_menu.show()


func _on_Boss_defeated(_boss: Boss) -> void:
	FreeUpgradeMenu.force_hide_display()
	get_tree().paused = true
	victory_menu.show()


func _on_GameOverMainMenuButton_pressed() -> void:
	_return_to_main_menu()


func _on_GameOverRestartButton_pressed() -> void:
	GameManager.stop_game()
	get_tree().paused = false
	await get_tree().process_frame
	
	game_over_menu.hide()
	get_tree().reload_current_scene()


func _on_VictoryMainMenuButton_pressed() -> void:
	_return_to_main_menu()
