extends Node2D

const spawn_flag_scene = preload("res://SpawnFlag.tscn")

var baseTile = preload("res://Tile.tscn")
var playerScene = preload("res://Data/Units/Player.tscn")
var chestScene = preload("res://Chest.tscn")
var width = 6
var height = 6
var tileSpacing = 1
var allEnemies = []
var spawn_locations = []
var unoccupiedTiles = []
var player = null

onready var allTiles = []
onready var gameboard
onready var game
onready var boss_overlay
onready var boss_health_bar
onready var boss_name
onready var victory_screen

signal game_start
signal menu_loaded
signal boss_spawned
signal boss_defeated

func startGame():
	randomize()
	gameboard = get_tree().get_nodes_in_group("gameboard")[0]
	generateTiles()
	spawnPlayer()
	game = get_tree().root.get_node("GameScene")
	boss_overlay = game.get_node("Canvas/BossOverlay")
	boss_health_bar = boss_overlay.get_node("BossHealthBar")
	boss_name = boss_overlay.get_node("BossName")
	victory_screen = game.get_node("Canvas/Victory")
	emit_signal("game_start")

func stop_game():
	GameManager.reset()
	TurnManager.reset()
	FreeUpgradeMenu.reset()
	MovementUtility.reset()
	ItemManager.reset()

func change_to_menu():
	get_tree().change_scene_to(load("res://MainMenu.tscn"))
	emit_signal("menu_loaded")

func reset():
	for child in gameboard.get_children():
		child.queue_free()
	
	allTiles = []
	unoccupiedTiles = []
	allEnemies = []
	spawn_locations = []
	player = null

func generateTiles():
	var index = 0
	
	for h in height:
		for w in width:
			var tile = spawnTile(w, h, index)
			index += 1
	
	unoccupiedTiles = allTiles

func spawnTile(w, h, index):
	var tile = baseTile.instance()
	tile.position.x += tile.get_child(0).get_rect().size.x*tile.get_child(0).scale.x  * w + w*tileSpacing
	tile.position.y += tile.get_child(0).get_rect().size.y*tile.get_child(0).scale.y * h + h*tileSpacing
	gameboard.add_child(tile)
	allTiles.append(tile)
	
	if w > 0:
		tile.leftTile = allTiles[index-1]
		tile.leftTile.rightTile = tile
	
	if h > 0:
		tile.topTile = allTiles[index - width]
		tile.topTile.bottomTile = tile
	
	return tile

func spawnPlayer():
	var spawnIndex = randi()%(allTiles.size())
	player = playerScene.instance()
	player.currentTile = allTiles[spawnIndex]
	allTiles[spawnIndex].occupied = player
	player.position = allTiles[spawnIndex].position
	occupyTile(allTiles[spawnIndex], player)
	gameboard.add_child(player)
	

func spawnChest():
	var spawnTile = getRandomUnoccupiedTile()
	var chest = chestScene.instance()
	chest.position = spawnTile.position
	chest.currentTile = spawnTile
	occupyTile(spawnTile, chest)
	gameboard.add_child(chest)

func spawnEnemies():
	if TurnManager.currentRound in TurnManager.roundSpawnData:
		# Spawn each unit in the spawn data
		for enemy in TurnManager.roundSpawnData[TurnManager.currentRound]:
			spawn_enemy(enemy, spawn_locations)

func spawn_enemy(enemy, spawn_locations):
	var occupiedTile = spawn_locations[0].currentTile
	spawn_locations[0].destroySelf()
	spawn_locations.pop_front()
	spawn_enemy_at_tile(enemy, occupiedTile)

func spawn_enemy_at_tile(enemy, tile):
	var instancedEnemy = enemy.instance()
	GameManager.occupyTile(tile, instancedEnemy)
	instancedEnemy.currentTile = tile
	instancedEnemy.position = tile.position
	gameboard.add_child(instancedEnemy)
	allEnemies.append(instancedEnemy)
	instancedEnemy.setup()

func removeEnemy(enemy):
	allEnemies.remove(allEnemies.find(enemy))

func new_spawn_locations():
	for spawn_point in spawn_locations:
		spawn_point.queue_free()
		spawn_locations = []
	
	if TurnManager.currentRound+1 in TurnManager.roundSpawnData:
		for x in TurnManager.roundSpawnData[TurnManager.currentRound+1].size():
			var spawn_flag = spawn_flag_scene.instance()
			var occupiedTile = GameManager.getRandomUnoccupiedTile()
			GameManager.occupyTile(occupiedTile, spawn_flag)
			spawn_flag.currentTile = occupiedTile
			spawn_flag.position = occupiedTile.position
			gameboard.add_child(spawn_flag)
			spawn_locations.append(spawn_flag)

func setup_boss(boss_data):
	boss_name.bbcode_text = "[shake]"+boss_data.name
	boss_overlay.visible = true
	emit_signal("boss_spawned", boss_data.boss_music)

func boss_defeated():
	boss_overlay.visible = false
	emit_signal("boss_defeated")

func trigger_victory_screen():
	game.game_won()

func occupyTile(tile, occupant):
	tile.occupied = occupant
	var tileIndex = unoccupiedTiles.find(tile)
	if tileIndex != -1:
		unoccupiedTiles.remove(tileIndex)

func unoccupyTile(tile):
	if !tile:
		return
	
	tile.occupied = null
	unoccupiedTiles.append(tile)

func getRandomUnoccupiedTile():
	return unoccupiedTiles[randi()%(unoccupiedTiles.size())]
	
