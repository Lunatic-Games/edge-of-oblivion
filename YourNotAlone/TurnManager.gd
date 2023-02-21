extends Node

signal playerTurnEnded

var goblinScene = preload("res://Data/Units/Enemies/Goblin.tscn")
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
var currentRound = 0

func initialize():
	call_deferred("handleRoundUpdate")

func reset():
	currentRound = 0
	currentTurnState = turnState.player

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
	handleRoundUpdate()
	currentTurnState = turnState.player

func handleEnemyTurn():
	for enemy in GameManager.allEnemies:
		enemy.activate()
	
	startPlayerTurn()

func handleRoundUpdate():
	currentRound += 1
	GameManager.spawnEnemies()
	GameManager.new_spawn_locations()
