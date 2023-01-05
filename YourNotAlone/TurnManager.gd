extends Node

signal playerTurnEnded

var goblinScene = preload("res://Goblin.tscn")
var roundSpawnData = {
	1:[goblinScene, goblinScene],
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
			var occupiedTile = GameManager.getRandomUnoccupiedTile()
			GameManager.occupyTile(occupiedTile, instancedEnemy)
			instancedEnemy.currentTile = occupiedTile
			instancedEnemy.position = occupiedTile.position
			get_tree().root.add_child(instancedEnemy)
			allEnemies.append(instancedEnemy)
			yield(instancedEnemy.setup(), "completed")
	yield(get_tree(), "idle_frame")

func new_spawn_locations():
	if currentRound in roundSpawnData:
		for x in roundSpawnData[currentRound].size():
			# Create a spawn point
			# add it to the spawnpoints data
			pass

func removeEnemy(enemy):
	allEnemies.remove(allEnemies.find(enemy))
