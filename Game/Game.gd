class_name Game
extends Node2D

var level_data: LevelData = null
var level: Level = null
var game_mode: GameMode = null

var spawn_handler: SpawnHandler = SpawnHandler.new()
var run_stats: RunStats = RunStats.new()
var queued_level_transition: LevelData = null

var run_over: bool = false

@onready var player_overlay: PlayerOverlay = $HUD/PlayerOverlay
@onready var boss_overlay: BossOverlay = $HUD/BossOverlay

@onready var upgrade_menu: UpgradeMenu = $Menus/UpgradeMenu
@onready var victory_menu: VictoryMenu = $Menus/VictoryMenu
@onready var game_over_menu: GameOverMenu = $Menus/GameOverMenu
@onready var pause_menu: PauseMenu = $Menus/PauseMenu
@onready var fade_animator: AnimationPlayer = $FadeOverlay/FadePlayer


func _ready() -> void:
	randomize()
	
	if level_data == null:
		var game_config: GameConfig = load("res://Data/Config/GameConfig.tres")
		level_data = game_config.starting_level_data
	
	await new_level_setup()
	GlobalSignals.run_started.emit()


func new_level_setup() -> void:
	player_overlay.visible = level_data.game_mode.show_player_ui_overlay
	
	level = level_data.level_scene.instantiate()
	level.setup(level_data)
	add_child(level)
	move_child(level, spawn_handler.get_index() + 1)
	await level.board.tile_generation_completed
	
	GlobalSignals.initial_level_setup_completed.emit(self)
	
	game_mode = GameMode.new(self, level_data.game_mode)


func transition_to_new_level(new_level_data: LevelData) -> void:
	set_process(false)
	fade_animator.play("fade_out")
	await fade_animator.animation_finished
	if new_level_data.persist_player_on_entering:
		var player: Player = GlobalGameState.get_player()
		if player:
			player.reparent(self)
	
	if level != null:
		level.queue_free()
	
	level_data = new_level_data
	new_level_setup()
	set_process(true)
	fade_animator.play("fade_in")


func _process(_delta: float) -> void:
	if game_mode != null and run_over == false and upgrade_menu.has_priority == false:
		game_mode.update()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pause"):
		return
	
	if run_over or pause_menu.visible:
		return
	
	get_viewport().set_input_as_handled()
	pause_menu.pause_and_fade_in()


func victory():
	if run_over:
		return
	
	run_over = true
	GlobalSignals.run_ended.emit(true)
	await get_tree().create_timer(1.0).timeout
	
	var gain_result: AccountXPGainResult = GlobalAccount.gain_xp(run_stats.xp_gained)
	victory_menu.run_summary.update(gain_result)
	Saving.save_progress_to_file()
	
	victory_menu.show()


func game_over():
	if run_over:
		return
	
	upgrade_menu.hide()
	run_over = true
	GlobalSignals.run_ended.emit(false)
	await get_tree().create_timer(1.0).timeout
	
	var gain_result: AccountXPGainResult = GlobalAccount.gain_xp(run_stats.xp_gained)
	game_over_menu.run_summary.update(gain_result)
	Saving.save_progress_to_file()
	
	game_over_menu.show()


func check_for_upgrades() -> bool:
	if upgrade_menu.n_queued_upgrades > 0 and run_over == false:
		upgrade_menu.display()
		return true
	
	return false


func check_for_level_transition() -> bool:
	if queued_level_transition != null and run_over == false:
		transition_to_new_level(queued_level_transition)
		queued_level_transition = null
		return true
	
	return false
