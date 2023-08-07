class_name Game
extends Node2D


var level_data: LevelData = load("res://Data/Levels/TheEdge/TheEdge.tres")
var level: Level = null
var player: Player = null

var round_manager: RoundManager = RoundManager.new()
var spawn_handler: SpawnHandler = SpawnHandler.new()
var run_stats: RunStats = RunStats.new()
var queued_level_transition: LevelData = null

@onready var player_overlay: PlayerOverlay = $HUD/PlayerOverlay
@onready var boss_overlay: BossOverlay = $HUD/BossOverlay

@onready var upgrade_menu: UpgradeMenu = $Menus/UpgradeMenu
@onready var victory_menu: VictoryMenu = $Menus/VictoryMenu
@onready var game_over_menu: GameOverMenu = $Menus/GameOverMenu
@onready var pause_menu: PauseMenu = $Menus/PauseMenu


func _ready() -> void:
	randomize()
	
	level = level_data.level_scene.instantiate()
	level.setup(level_data)
	add_child(level)
	move_child(level, spawn_handler.get_index() + 1)
	player_overlay.visible = level_data.is_combat_level
	await level.board.tile_generation_completed
	
	GlobalGameState.new_game(self)
	GlobalSignals.boss_defeated.connect(_on_boss_defeated)
	
	player = spawn_handler.spawn_player()
	player.inventory.add_starting_items()
	player.health.died.connect(_on_player_died)
	player.levelling.levelled_up.connect(_on_player_levelled_up)
	
	spawn_flags_for_next_round()
	
	if level_data.gateway_spawn_condition == LevelData.GatewaySpawnCondition.ON_LOAD:
		if level_data.next_level != null:
			spawn_handler.spawn_gateway(level_data.next_level)
	
	GlobalSignals.run_started.emit()


func _process(_delta: float) -> void:
	if is_instance_valid(player) and player.health.is_alive():
		round_manager.update(player, self)


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
	GlobalSignals.run_ended.emit(true)
	await get_tree().create_timer(1.0).timeout
	
	var gain_result: AccountXPGainResult = GlobalAccount.gain_xp(run_stats.xp_gained)
	victory_menu.run_summary.update(gain_result)
	Saving.save_progress_to_file()
	
	victory_menu.show()


func game_over():
	if GlobalGameState.game_ended:
		return
	
	upgrade_menu.hide()
	GlobalGameState.game_ended = true
	GlobalSignals.run_ended.emit(false)
	await get_tree().create_timer(1.0).timeout
	
	var gain_result: AccountXPGainResult = GlobalAccount.gain_xp(run_stats.xp_gained)
	game_over_menu.run_summary.update(gain_result)
	Saving.save_progress_to_file()
	
	game_over_menu.show()


func check_for_upgrades() -> void:
	if upgrade_menu.n_queued_upgrades > 0 and GlobalGameState.game_ended == false:
		upgrade_menu.display()


func check_for_level_transition() -> void:
	if queued_level_transition != null:
		set_process(false)
		LevelLoading.load_level(get_tree(), queued_level_transition)


func spawn_enemies_for_round() -> void:
	if level.data.level_waves == null:
		return
	
	var round_i: int = round_manager.current_round
	var enemies_to_spawn: Array[EnemyData] = level.data.level_waves.get_enemies_for_round(round_i)
	spawn_handler.spawn_enemies(enemies_to_spawn)


func spawn_flags_for_next_round() -> void:
	if level.data.level_waves == null:
		return
	
	var round_i: int = round_manager.current_round
	var n_enemies_next_turn: int = level.data.level_waves.get_enemies_for_round(round_i + 1).size()
	spawn_handler.spawn_flags_for_next_turn(n_enemies_next_turn)


func _on_player_levelled_up(_player_level: int):
	upgrade_menu.queue_upgrade()


func _on_player_died() -> void:
	game_over()


func _on_boss_defeated(_boss: Enemy) -> void:
	victory()
