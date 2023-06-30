class_name Game
extends Node2D


const MAIN_MENU_SCENE: PackedScene = preload("res://Menus/MainMenu/MainMenu.tscn")

@export var level_scene: PackedScene
@export var all_items: Array[ItemData]

var level: Level

@onready var turn_manager: TurnManager = $TurnManager
@onready var spawn_handler: SpawnHandler = $SpawnHandler

@onready var upgrade_menu: CanvasLayer = $Menus/UpgradeMenu
@onready var victory_screen: CanvasLayer = $Menus/VictoryScreen
@onready var game_over_screen: CanvasLayer = $Menus/GameOverScreen


func _ready() -> void:
	randomize()
	
	GlobalSignals.player_died.connect(_on_Player_died)  # Game over!
	GlobalSignals.boss_defeated.connect(_on_Boss_defeated)  # Game won!
	
	GlobalSignals.new_round_started.connect(_on_new_round_started)
	
	level = level_scene.instantiate()
	add_child(level)
	move_child(level, spawn_handler.get_index() + 1)
	await level.board.tile_generation_completed
	
	GlobalGameState.new_game(self)
	var player: Player = spawn_handler.spawn_player()
	player.add_starting_items()
	
	upgrade_menu.setup(all_items)
	turn_manager.new_round()
	
	GlobalSignals.game_started.emit()


func _on_new_round_started() -> void:
	var round_i: int = turn_manager.current_round
	var enemies_to_spawn: Array[PackedScene] = level.waves.get_enemies_for_turn(round_i) as Array[PackedScene]
	spawn_handler.spawn_enemies(enemies_to_spawn)

	var n_enemies_next_turn: int = level.waves.get_enemies_for_turn(round_i + 1).size()
	spawn_handler.spawn_flags_for_next_turn(n_enemies_next_turn)


func _return_to_main_menu() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)


func _on_Player_died(_player: Player) -> void:
	if GlobalGameState.game_ended:
		return
	
	GlobalGameState.game_ended = true
	upgrade_menu.hide()
	await get_tree().create_timer(1.0).timeout
	
	game_over_screen.show()


func _on_Boss_defeated(_boss: Boss) -> void:
	if GlobalGameState.game_ended:
		return
	
	GlobalGameState.game_ended = true
	upgrade_menu.hide()
	await get_tree().create_timer(1.0).timeout
	
	victory_screen.show()


func _on_VictoryScreen_PlayAgainButton_pressed() -> void:
	get_tree().reload_current_scene()


func _on_VictoryScreen_MainMenuButton_pressed() -> void:
	_return_to_main_menu()


func _on_GameOverScreen_PlayAgainButton_pressed() -> void:
	get_tree().reload_current_scene()


func _on_GameOverScreen_MainMenuButton_pressed() -> void:
	_return_to_main_menu()
