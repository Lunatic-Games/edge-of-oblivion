extends Node2D

signal main_menu_loaded

const MAIN_MENU_SCENE: PackedScene = preload("res://Menus/MainMenu/MainMenu.tscn")
const SPAWN_FLAG_SCENE: PackedScene = preload("res://Data/Indicators/SpawnFlag/SpawnFlag.tscn")
const TILE_SCENE: PackedScene = preload("res://GameScene/Tile.tscn")
const PLAYER_SCENE: PackedScene = preload("res://Data/Units/Player/Player.tscn")
const CHEST_SCENE: PackedScene = preload("res://Data/Objects/Chest.tscn")

var width: int = 6
var height: int = 6
var tile_spacing: int = 1
var all_enemies: Array[Enemy] = []
var spawn_locations: Array[SpawnFlag] = []
var unoccupied_tiles: Array[Tile] = []
var all_tiles: Array[Tile] = []

var player: Player = null
var gameboard: Node2D = null
var game: GameScene = null
var boss_overlay: Control = null
var boss_health_bar: ProgressBar = null
var boss_name: RichTextLabel = null
var victory_screen: Control = null


func start_game() -> void:
	randomize()
	
	gameboard = get_tree().get_nodes_in_group("gameboard")[0]
	generate_tiles()
	spawn_player()
	
	game = get_tree().root.get_node("GameScene")
	boss_overlay = game.get_node("HUD/BossOverlay")
	boss_health_bar = boss_overlay.get_node("HealthBar")
	boss_name = boss_overlay.get_node("Title")
	victory_screen = game.get_node("Menus/VictoryPanel")
	
	if not GlobalSignals.boss_spawned.is_connected(_on_Boss_spawned):
		GlobalSignals.boss_spawned.connect(_on_Boss_spawned)
	
	GlobalSignals.game_started.emit()


func stop_game() -> void:
	GameManager.reset()
	TurnManager.reset()
	FreeUpgradeMenu.reset()
	MovementUtility.reset()
	ItemManager.reset()


func change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
	main_menu_loaded.emit()


func reset() -> void:
	if gameboard != null:
		for child in gameboard.get_children():
			child.queue_free()
	
	all_tiles = []
	unoccupied_tiles = []
	all_enemies = []
	spawn_locations = []
	player = null


func generate_tiles() -> void:
	var index: int = 0
	
	for h in height:
		for w in width:
			var _tile: Tile = spawn_tile(w, h, index)
			index += 1
	
	unoccupied_tiles = all_tiles


func spawn_tile(w: int, h: int, index: int) -> Tile:
	var tile: Tile = TILE_SCENE.instantiate()
	var tile_size: Vector2 = tile.get_child(0).get_rect().size
	tile.position.x += tile_size.x * tile.get_child(0).scale.x * w + w * tile_spacing
	tile.position.y += tile_size.y * tile.get_child(0).scale.y * h + h * tile_spacing
	
	gameboard.add_child(tile)
	all_tiles.append(tile)
	
	if w > 0:
		tile.left_tile = all_tiles[index-1]
		tile.left_tile.right_tile = tile
	
	if h > 0:
		tile.top_tile = all_tiles[index - width]
		tile.top_tile.bottom_tile = tile
	
	return tile


func spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	
	var player_spawn_tile: Tile = all_tiles.pick_random()
	assert(player_spawn_tile != null)
	
	player.current_tile = player_spawn_tile
	player_spawn_tile.occupant = player
	player.position = player_spawn_tile.position
	
	occupy_tile(player_spawn_tile, player)
	gameboard.add_child(player)


func spawn_chest() -> void:
	var chest: Chest = CHEST_SCENE.instantiate()
	
	var chest_spawn_tile: Tile = get_random_unoccupied_tile()
	chest.position = chest_spawn_tile.position
	chest.current_tile = chest_spawn_tile
	
	occupy_tile(chest_spawn_tile, chest)
	gameboard.add_child(chest)


func spawn_enemies() -> void:
	if not TurnManager.current_round in TurnManager.round_spawn_data:
		return
	
	for enemy in TurnManager.round_spawn_data[TurnManager.current_round]:
		spawn_enemy(enemy)


func spawn_enemy(enemy) -> void:
	var occupied_tile: Tile = spawn_locations[0].current_tile
	spawn_locations[0].destroy_self()
	spawn_locations.pop_front()
	spawn_enemy_at_tile(enemy, occupied_tile)


func spawn_enemy_at_tile(enemy_scene: PackedScene, tile: Tile) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	
	GameManager.occupy_tile(tile, enemy)
	enemy.current_tile = tile
	enemy.position = tile.position
	gameboard.add_child(enemy)
	all_enemies.append(enemy)
	enemy.setup()


func remove_enemy(enemy: Enemy) -> void:
	all_enemies.erase(enemy)


func calculate_spawn_location_for_next_round() -> void:
	for spawn_point in spawn_locations:
		spawn_point.queue_free()
		spawn_locations = []
	
	var next_round: int = TurnManager.current_round+1
	
	if not (next_round in TurnManager.round_spawn_data):
		return
	
	for _i in TurnManager.round_spawn_data[next_round].size():
		var spawn_flag: SpawnFlag = SPAWN_FLAG_SCENE.instantiate()
		var occupied_tile: Tile = GameManager.get_random_unoccupied_tile()
		if occupied_tile == null:
			# No more room to spawn
			break
		
		GameManager.occupy_tile(occupied_tile, spawn_flag)
		spawn_flag.current_tile = occupied_tile
		spawn_flag.position = occupied_tile.position
		gameboard.add_child(spawn_flag)
		spawn_locations.append(spawn_flag)


func _on_Boss_spawned(_boss: Boss, boss_data: BossData) -> void:
	boss_name.text = "[shake]" + boss_data.name
	boss_overlay.visible = true


func boss_has_been_defeated() -> void:
	boss_overlay.visible = false


func trigger_victory_screen() -> void:
	game.game_won()


func occupy_tile(tile: Tile, occupant: Occupant) -> void:
	tile.occupant = occupant
	
	if occupant != null:
		unoccupied_tiles.erase(tile)


func unoccupy_tile(tile: Tile) -> void:
	if tile == null:
		return
	
	tile.occupant = null
	unoccupied_tiles.append(tile)


func get_random_unoccupied_tile() -> Tile:
	if unoccupied_tiles.is_empty():
		return null
	
	return unoccupied_tiles.pick_random()
