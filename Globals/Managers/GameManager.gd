extends Node2D

signal game_started
signal main_menu_loaded
signal boss_spawned
signal boss_defeated

const MAIN_MENU_SCENE = preload("res://Menus/MainMenu/MainMenu.tscn")
const SPAWN_FLAG_SCENE = preload("res://Data/Indicators/SpawnFlag/SpawnFlag.tscn")
const TILE_SCENE = preload("res://GameScene/Tile.tscn")
const PLAYER_SCENE = preload("res://Data/Units/Player/Player.tscn")
const CHEST_SCENE = preload("res://Data/Objects/Chest.tscn")

var width = 6
var height = 6
var tile_spacing = 1
var all_enemies = []
var spawn_locations = []
var unoccupied_tiles = []
var all_tiles = []

var player = null
var gameboard = null
var game = null
var boss_overlay = null
var boss_health_bar = null
var boss_name = null
var victory_screen = null


func start_game():
	randomize()
	
	gameboard = get_tree().get_nodes_in_group("gameboard")[0]
	generate_tiles()
	spawn_player()
	
	game = get_tree().root.get_node("GameScene")
	boss_overlay = game.get_node("HUD/BossOverlay")
	boss_health_bar = boss_overlay.get_node("HealthBar")
	boss_name = boss_overlay.get_node("Title")
	victory_screen = game.get_node("Menus/VictoryPanel")
	
	game_started.emit()


func stop_game():
	GameManager.reset()
	TurnManager.reset()
	FreeUpgradeMenu.reset()
	MovementUtility.reset()
	ItemManager.reset()


func change_to_main_menu():
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
	main_menu_loaded.emit()


func reset():
	for child in gameboard.get_children():
		child.queue_free()
	
	all_tiles = []
	unoccupied_tiles = []
	all_enemies = []
	spawn_locations = []
	player = null


func generate_tiles():
	var index = 0
	
	for h in height:
		for w in width:
			var _tile = spawn_tile(w, h, index)
			index += 1
	
	unoccupied_tiles = all_tiles


func spawn_tile(w, h, index):
	var tile = TILE_SCENE.instantiate()
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

func spawn_player():
	player = PLAYER_SCENE.instantiate()
	
	var player_spawn_tile = all_tiles.pick_random()
	player.current_tile = player_spawn_tile
	player_spawn_tile.occupant = player
	player.position = player_spawn_tile.position
	
	occupy_tile(player_spawn_tile, player)
	gameboard.add_child(player)


func spawn_chest():
	var chest = CHEST_SCENE.instantiate()
	
	var chest_spawn_tile = get_random_unoccupied_tile()
	chest.position = chest_spawn_tile.position
	chest.current_tile = chest_spawn_tile
	
	occupy_tile(chest_spawn_tile, chest)
	gameboard.add_child(chest)


func spawn_enemies():
	if not TurnManager.current_round in TurnManager.round_spawn_data:
		return
	
	for enemy in TurnManager.round_spawn_data[TurnManager.current_round]:
		spawn_enemy(enemy)


func spawn_enemy(enemy):
	var occupied_tile = spawn_locations[0].current_tile
	spawn_locations[0].destroy_self()
	spawn_locations.pop_front()
	spawn_enemy_at_tile(enemy, occupied_tile)


func spawn_enemy_at_tile(enemy_scene, tile):
	var enemy = enemy_scene.instantiate()
	
	GameManager.occupy_tile(tile, enemy)
	enemy.current_tile = tile
	enemy.position = tile.position
	gameboard.add_child(enemy)
	all_enemies.append(enemy)
	enemy.setup()


func remove_enemy(enemy):
	all_enemies.erase(enemy)


func calculate_spawn_location_for_next_round():
	for spawn_point in spawn_locations:
		spawn_point.queue_free()
		spawn_locations = []
	
	var next_round: int = TurnManager.current_round+1
	
	if not (next_round in TurnManager.round_spawn_data):
		return
	
	for _i in TurnManager.round_spawn_data[next_round].size():
		var spawn_flag = SPAWN_FLAG_SCENE.instantiate()
		var occupied_tile = GameManager.get_random_unoccupied_tile()
		
		GameManager.occupy_tile(occupied_tile, spawn_flag)
		spawn_flag.current_tile = occupied_tile
		spawn_flag.position = occupied_tile.position
		gameboard.add_child(spawn_flag)
		spawn_locations.append(spawn_flag)


func setup_boss(boss_data):
	boss_name.text = "[shake]" + boss_data.name
	boss_overlay.visible = true
	boss_spawned.emit(boss_data)


func boss_has_been_defeated():
	boss_overlay.visible = false
	boss_defeated.emit()


func trigger_victory_screen():
	game.game_won()


func occupy_tile(tile, occupant):
	tile.occupant = occupant
	unoccupied_tiles.erase(tile)


func unoccupy_tile(tile):
	if tile == null:
		return
	
	tile.occupant = null
	unoccupied_tiles.append(tile)


func get_random_unoccupied_tile():
	return unoccupied_tiles.pick_random()
