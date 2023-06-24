class_name GameScene
extends Node2D


@export var all_items: Array[ItemData]

@onready var turn_manager: TurnManager = $TurnManager
@onready var spawn_manager: SpawnManager = $SpawnManager
@onready var level: Level = $TheEdge

@onready var upgrade_menu: CanvasLayer = $Menus/UpgradeMenu
@onready var victory_screen: CanvasLayer = $Menus/VictoryScreen
@onready var game_over_screen: CanvasLayer = $Menus/GameOverScreen


func _ready() -> void:
	GlobalSignals.player_died.connect(_on_Player_died)  # Game over!
	GlobalSignals.boss_defeated.connect(_on_Boss_defeated)  # Game won!
	GlobalSignals.new_round_started.connect(_on_new_round_started)
	
	await level.board.tile_generation_completed
	
	GameManager.new_game()
	var player: Player = spawn_manager.spawn_player()
	GameManager.player = player
	player.add_starting_items()
	
	upgrade_menu.setup(all_items)
	turn_manager.initialize()


func _on_new_round_started() -> void:
	var round_i: int = turn_manager.current_round
	var enemies_to_spawn: Array[PackedScene] = level.waves.get_enemies_for_turn(round_i) as Array[PackedScene]
	spawn_manager.spawn_enemies(enemies_to_spawn)

	var n_enemies_next_turn: int = level.waves.get_enemies_for_turn(round_i + 1).size()
	spawn_manager.spawn_flags_for_next_turn(n_enemies_next_turn)


func _return_to_main_menu() -> void:
	GameManager.change_to_main_menu()
	GameManager.stop_game()
	get_tree().paused = false


func _on_Player_died(_player: Player) -> void:
	if GameManager.game_ended:
		return
	
	GameManager.game_ended = true
	upgrade_menu.hide()
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
