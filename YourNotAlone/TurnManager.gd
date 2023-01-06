extends Node

const spawn_flag_scene = preload("res://SpawnFlag.tscn")

signal playerTurnEnded

var goblinScene = preload("res://Goblin.tscn")
var roundSpawnData = {
	2:[goblinScene, goblinScene],
	5:[goblinScene],
	9:[goblinScene],
	15:[goblinScene, goblinScene],
	19:[goblinScene, goblinScene],
	23:[goblinScene, goblinScene],
	27:[goblinScene, goblinScene],
	31:[goblinScene, goblinScene, goblinScene],
	35:[goblinScene, goblinScene, goblinScene],
	38:[goblinScene, goblinScene, goblinScene],
	42:[goblinScene, goblinScene, goblinScene, goblinScene]
	}

enum turnState {enemy, player}
var currentTurnState = turnState.player
var allEnemies = []
var currentRound = 0
var spawn_locations = []

func initialize():
	call_deferred("handleRoundUpdate")

func isPlayerTurn():
	if currentTurnState == turnState.player:
		return true
	return false

func itemPhaseEnded():
	startEnemyTurn()

func startEnemyTurn():
	currentTurnState = turnState.enemy
	handleEnemyTurn()

func endPlayerTurn():
	emit_signal("playerTurnEnded")

func startPlayerTurn():
	yield(handleRoundUpdate(), "completed")
	currentTurnState = turnState.player

func handleEnemyTurn():
	for enemy in allEnemies:
		enemy.activate()
	
	startPlayerTurn()

func handleRoundUpdate():
	currentRound += 1
	yield(spawnEnemies(), "completed")
	new_spawn_locations()

func spawnEnemies():
	if currentRound in roundSpawnData:
		# Spawn each unit in the spawn data
		for enemy in roundSpawnData[currentRound]:
			yield(get_tree().create_timer(0.2), "timeout")
			var instancedEnemy = enemy.instance()
			var occupiedTile = spawn_locations[0].currentTile
			spawn_locations[0].destroySelf()
			spawn_locations.pop_front()
			GameManager.occupyTile(occupiedTile, instancedEnemy)
			instancedEnemy.currentTile = occupiedTile
			instancedEnemy.position = occupiedTile.position
			get_tree().root.add_child(instancedEnemy)
			allEnemies.append(instancedEnemy)
			yield(instancedEnemy.setup(), "completed")
	yield(get_tree(), "idle_frame")

func new_spawn_locations():
	for spawn_point in spawn_locations:
		spawn_point.queue_free()
		spawn_locations = []
	
	if currentRound+1 in roundSpawnData:
		for x in roundSpawnData[currentRound+1].size():
			var spawn_flag = spawn_flag_scene.instance()
			var occupiedTile = GameManager.getRandomUnoccupiedTile()
			GameManager.occupyTile(occupiedTile, spawn_flag)
			spawn_flag.currentTile = occupiedTile
			spawn_flag.position = occupiedTile.position
			get_tree().root.add_child(spawn_flag)
			spawn_locations.append(spawn_flag)

func removeEnemy(enemy):
	allEnemies.remove(allEnemies.find(enemy))
