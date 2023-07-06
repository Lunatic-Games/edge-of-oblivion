class_name Game
extends Node2D


@export var level_data: LevelData

var level: Level

@onready var turn_manager: TurnManager = $TurnManager
@onready var spawn_handler: SpawnHandler = $SpawnHandler
@onready var run_stats: RunStats = $RunStats

@onready var upgrade_menu: UpgradeMenu = $Menus/UpgradeMenu
@onready var victory_menu: VictoryMenu = $Menus/VictoryMenu
@onready var game_over_menu: GameOverMenu = $Menus/GameOverMenu
@onready var pause_menu: PauseMenu = $Menus/PauseMenu


func _ready() -> void:
	randomize()
	
	GlobalSignals.player_died.connect(_on_Player_died)  # Game over!
	GlobalSignals.boss_defeated.connect(_on_Boss_defeated)  # Game won!
	
	GlobalSignals.new_round_started.connect(_on_new_round_started)
	GlobalSignals.player_levelled_up.connect(_on_player_levelled_up)
	
	level = level_data.level_scene.instantiate()
	add_child(level)
	move_child(level, spawn_handler.get_index() + 1)
	await level.board.tile_generation_completed
	
	GlobalGameState.new_game(self)
	var player: Player = spawn_handler.spawn_player()
	player.add_starting_items()
	
	turn_manager.new_round()
	
	GlobalSignals.game_started.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pause"):
		return
	
	if GlobalGameState.game_ended or pause_menu.visible:
		return
	
	get_viewport().set_input_as_handled()
	pause_menu.pause_and_fade_in()


func victory():
	if GlobalGameState.game_ended:
		return
	
	GlobalGameState.game_ended = true
	GlobalSignals.game_ended.emit()
	await get_tree().create_timer(1.0).timeout
	
	var gain_result: AccountXPGainResult = GlobalAccount.gain_xp(run_stats.xp_gained)
	game_over_menu.run_summary.update(gain_result)
	Saving.save_progress_to_file()
	
	game_over_menu.show()


func game_over():
	if GlobalGameState.game_ended:
		return
	
	GlobalGameState.game_ended = true
	GlobalSignals.game_ended.emit()
	await get_tree().create_timer(1.0).timeout
	
	var gain_result: AccountXPGainResult = GlobalAccount.gain_xp(run_stats.xp_gained)
	victory_menu.run_summary.update(gain_result)
	Saving.save_progress_to_file()
	
	victory_menu.show()


func _on_new_round_started() -> void:
	var round_i: int = turn_manager.current_round
	var enemies_to_spawn: Array[PackedScene] = level.waves.get_enemies_for_turn(round_i) as Array[PackedScene]
	spawn_handler.spawn_enemies(enemies_to_spawn)

	var n_enemies_next_turn: int = level.waves.get_enemies_for_turn(round_i + 1).size()
	spawn_handler.spawn_flags_for_next_turn(n_enemies_next_turn)


func _on_player_levelled_up(_player: Player):
	upgrade_menu.display()


func _on_Player_died(_player: Player) -> void:
	victory()


func _on_Boss_defeated(_boss: Boss) -> void:
	game_over()
