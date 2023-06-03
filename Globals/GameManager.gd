extends Node2D

signal main_menu_loaded

const MAIN_MENU_SCENE: PackedScene = preload("res://Menus/MainMenu/MainMenu.tscn")
const SPAWN_FLAG_SCENE: PackedScene = preload("res://Data/Indicators/SpawnFlag/SpawnFlag.tscn")
const PLAYER_SCENE: PackedScene = preload("res://Data/Units/Player/Player.tscn")
const CHEST_SCENE: PackedScene = preload("res://Data/Objects/Chest.tscn")

var all_enemies: Array[Enemy] = []
var spawn_flags: Array[SpawnFlag] = []

var player: Player = null
var board: Board = null
var game: GameScene = null
var boss_overlay: Control = null
var boss_health_bar: ProgressBar = null
var boss_name: RichTextLabel = null
var victory_screen: Control = null


func start_game() -> void:
	randomize()
	
	game = get_tree().root.get_node("GameScene")
	boss_overlay = game.get_node("HUD/BossOverlay")
	boss_health_bar = boss_overlay.get_node("Container/HealthBar")
	boss_name = boss_overlay.get_node("Container/Title")
	victory_screen = game.get_node("Menus/VictoryPanel")
	
	board = game.board
	
	if not GlobalSignals.boss_spawned.is_connected(_on_Boss_spawned):
		GlobalSignals.boss_spawned.connect(_on_Boss_spawned)
	
	await board.tile_generation_completed
	player = spawn_player()
	player.add_starting_items()
	
	GlobalSignals.game_started.emit()


func stop_game() -> void:
	reset()
	TurnManager.reset()


func change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
	main_menu_loaded.emit()


func reset() -> void:
	all_enemies.clear()
	spawn_flags.clear()
	player = null


func spawn_player() -> Player:
	var spawn_tile: Tile = board.get_random_unoccupied_tile()
	assert(spawn_tile != null, "No free tile to spawn player on.")
	return spawn_occupant_on_tile(PLAYER_SCENE, spawn_tile)


func spawn_enemies() -> void:
	if not TurnManager.current_round in TurnManager.round_spawn_data:
		return
	
	var enemies_to_spawn: Array = TurnManager.round_spawn_data[TurnManager.current_round]
	
	for enemy_scene in enemies_to_spawn:
		var spawn_flag: SpawnFlag = spawn_flags.pop_front()
		assert(spawn_flag, "More enemies to spawn then there are spawn flags.")
		spawn_flag.destroy_self()
		
		var _enemy: Enemy = spawn_enemy_on_tile(enemy_scene, spawn_flag.current_tile)
	
	assert(spawn_flags.is_empty(), "More spawn flags than enemies to spawn for this round.")


func spawn_enemy_on_tile(enemy_scene: PackedScene, tile: Tile) -> Enemy:
	var enemy: Enemy = spawn_occupant_on_tile(enemy_scene, tile)
	all_enemies.append(enemy)
	enemy.died.connect(_on_enemy_died.bind(enemy))
	return enemy


func calculate_spawn_location_for_next_round() -> void:
	var next_round: int = TurnManager.current_round + 1
	
	if not (next_round in TurnManager.round_spawn_data):
		return
	
	var n_spawns = TurnManager.round_spawn_data[next_round].size()
	for _i in n_spawns:
		var spawn_tile: Tile = board.get_random_unoccupied_tile()
		if spawn_tile == null:
			# No more room to spawn
			break
		
		var spawn_flag: SpawnFlag = spawn_occupant_on_tile(SPAWN_FLAG_SCENE, spawn_tile)
		spawn_flags.append(spawn_flag)


func spawn_occupant_on_tile(occupant_scene: PackedScene, tile: Tile) -> Occupant:
	var occupant: Occupant = occupant_scene.instantiate()
	assert(occupant != null, "Failed to instantiate PackedScene as an Occupant")
	
	board.add_child(occupant)
	
	tile.occupant = occupant
	occupant.current_tile = tile
	occupant.global_position = tile.global_position
	
	return occupant


func _on_Boss_spawned(boss: Boss) -> void:
	boss_name.text = "[shake]" + boss.display_name + "[/shake]"
	boss_overlay.visible = true


func _on_enemy_died(enemy: Enemy) -> void:
	all_enemies.erase(enemy)
