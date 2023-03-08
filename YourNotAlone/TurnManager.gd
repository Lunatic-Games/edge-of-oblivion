extends Node

signal playerTurnEnded

var goblinScene = preload("res://Data/Units/Enemies/Faded.tscn")
var lost_ranger_scene = preload("res://Data/Units/Enemies/LostRanger.tscn")
var forsworn_pike_scene = preload("res://Data/Units/Enemies/ForswornPike.tscn")
var forgotten_king_scene = preload("res://Data/Units/Enemies/Boss/ForgottenKing.tscn")

var roundSpawnData = {
	2:[goblinScene],
	5:[goblinScene],
	9:[goblinScene],
	15:[lost_ranger_scene],
	19:[goblinScene, lost_ranger_scene],
	23:[goblinScene, goblinScene],
	27:[goblinScene],
	31:[goblinScene,lost_ranger_scene],
	35:[goblinScene, goblinScene],
	38:[goblinScene, goblinScene],
	42:[forsworn_pike_scene],
	46:[lost_ranger_scene, forsworn_pike_scene],
	50: [goblinScene, goblinScene, goblinScene],
	55: [forsworn_pike_scene],
	60: [forsworn_pike_scene, forsworn_pike_scene],
	65: [forgotten_king_scene],
	70: [forsworn_pike_scene, lost_ranger_scene],
	74: [goblinScene, forsworn_pike_scene],
	80: [forsworn_pike_scene, forsworn_pike_scene]
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
