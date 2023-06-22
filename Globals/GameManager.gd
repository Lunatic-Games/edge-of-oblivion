extends Node2D

signal main_menu_loaded

const MAIN_MENU_SCENE: PackedScene = preload("res://Menus/MainMenu/MainMenu.tscn")

var player: Player = null
var board: Board = null
var game: GameScene = null
var boss_overlay: Control = null
var boss_health_bar: ProgressBar = null
var boss_name: RichTextLabel = null

var game_ended: bool = false


func new_game() -> void:
	game_ended = false
	randomize()
	
	game = get_tree().root.get_node("GameScene")
	boss_overlay = game.get_node("HUD/BossOverlay")
	boss_health_bar = boss_overlay.get_node("Container/HealthBar")
	boss_name = boss_overlay.get_node("Container/Title")
	
	board = game.level.board
	
	if not GlobalSignals.boss_spawned.is_connected(_on_Boss_spawned):
		GlobalSignals.boss_spawned.connect(_on_Boss_spawned)


func stop_game() -> void:
	player = null
	game.turn_manager.reset()


func change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
	main_menu_loaded.emit()


func _on_Boss_spawned(boss: Boss) -> void:
	boss_name.text = "[shake]" + boss.display_name + "[/shake]"
	boss_overlay.visible = true
