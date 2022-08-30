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
	27:[goblinScene, goblinScene]
	}

enum turnState {enemy, player}
var currentTurnState = turnState.player
var allEnemies = []
var currentRound = 0

func _ready():
	handleRoundUpdate()

func isPlayerTurn():
	if currentTurnState == turnState.player:
		return true
	return false

func startEnemyTurn():
	currentTurnState = turnState.enemy
	handleEnemyTurn()

func endPlayerTurn():
	emit_signal("playerTurnEnded")
	startEnemyTurn()

func startPlayerTurn():
	handleRoundUpdate()
	currentTurnState = turnState.player

func handleEnemyTurn():
	for enemy in allEnemies:
		enemy.activate()
	
	startPlayerTurn()

func handleRoundUpdate():
	currentRound += 1
	
	spawnEnemies()

func spawnEnemies():
	if currentRound in roundSpawnData:
		print("Spawning Enemies\ncurrentRound=>",currentRound )
		# Spawn each unit in the spawn data
		for enemy in roundSpawnData[currentRound]:
			print("enemy=>", enemy)
			var instancedEnemy = enemy.instance()
			var occupiedTile = GameManager.getRandomUnoccupiedTile()
			GameManager.occupyTile(occupiedTile, instancedEnemy)
			instancedEnemy.currentTile = occupiedTile
			instancedEnemy.position = occupiedTile.position
			get_tree().root.call_deferred("add_child", instancedEnemy)
			allEnemies.append(instancedEnemy)

func removeEnemy(enemy):
	allEnemies.remove(allEnemies.find(enemy))
