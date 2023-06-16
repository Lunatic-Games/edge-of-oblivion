class_name GameScene
extends Node2D


@export var all_items: Array[ItemData]

@onready var board: Board = $Board

@onready var upgrade_menu: CanvasLayer = $Menus/UpgradeMenu
@onready var victory_screen: CanvasLayer = $Menus/VictoryScreen
@onready var game_over_screen: CanvasLayer = $Menus/GameOverScreen


func _ready() -> void:
	upgrade_menu.setup(all_items)
	GlobalSignals.player_died.connect(_on_Player_died)  # Game over!
	GlobalSignals.boss_defeated.connect(_on_Boss_defeated)  # Game won!
	
	GameManager.start_game()
	TurnManager.initialize()


func _return_to_main_menu() -> void:
	GameManager.change_to_main_menu()
	GameManager.stop_game()
	get_tree().paused = false


func _on_Player_died(_player: Player) -> void:
	if GameManager.game_ended:
		return
	
	GameManager.game_ended = true
	await get_tree().create_timer(1.0).timeout
	
	game_over_screen.show()


func _on_Boss_defeated(_boss: Boss) -> void:
	if GameManager.game_ended:
		return
	
	GameManager.game_ended = true
	upgrade_menu.hide()
	await get_tree().create_timer(1.0).timeout
	
	victory_screen.show()


func _on_GameOverMainMenuButton_pressed() -> void:
	_return_to_main_menu()


func _on_GameOverRestartButton_pressed() -> void:
	GameManager.stop_game()
	get_tree().reload_current_scene()


func _on_VictoryScreen_PlayAgainButton_pressed() -> void:
	GameManager.stop_game()
	get_tree().reload_current_scene()


func _on_VictoryScreen_MainMenuButton_pressed() -> void:
	GameManager.stop_game()
	_return_to_main_menu()


func _on_GameOverScreen_PlayAgainButton_pressed() -> void:
	GameManager.stop_game()
	get_tree().reload_current_scene()


func _on_GameOverScreen_MainMenuButton_pressed() -> void:
	GameManager.stop_game()
	_return_to_main_menu()
