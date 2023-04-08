extends Node

signal playerTurnEnded

var faded_scene = preload("res://Data/Units/Enemies/Faded.tscn")
var lost_ranger_scene = preload("res://Data/Units/Enemies/LostRanger.tscn")
var forsworn_pike_scene = preload("res://Data/Units/Enemies/ForswornPike.tscn")
var forgotten_king_scene = preload("res://Data/Units/Enemies/Boss/ForgottenKing.tscn")

var roundSpawnData = {
		2: [faded_scene],
		6: [faded_scene],
		12: [faded_scene, faded_scene],
		20: [faded_scene],
		26: [faded_scene],
		34: [faded_scene, faded_scene],
		40: [faded_scene],
		44: [faded_scene],
		55: [lost_ranger_scene, faded_scene],
		65: [lost_ranger_scene, lost_ranger_scene, lost_ranger_scene],
		75: [faded_scene, faded_scene],
		80: [faded_scene, lost_ranger_scene],
		85: [lost_ranger_scene, lost_ranger_scene, faded_scene],
		90: [faded_scene],
		100: [forsworn_pike_scene],
		105: [forsworn_pike_scene],
		115: [forsworn_pike_scene, forsworn_pike_scene, forsworn_pike_scene, forsworn_pike_scene],
		125: [faded_scene, lost_ranger_scene],
		135: [forsworn_pike_scene],
		145: [forsworn_pike_scene, lost_ranger_scene, lost_ranger_scene],
		150: [forgotten_king_scene],
		152: [forsworn_pike_scene, forsworn_pike_scene, faded_scene, faded_scene, lost_ranger_scene],
		158: [forsworn_pike_scene, lost_ranger_scene, faded_scene],
		168: [lost_ranger_scene, lost_ranger_scene, lost_ranger_scene, forsworn_pike_scene, forsworn_pike_scene],
		175: [forsworn_pike_scene, faded_scene, lost_ranger_scene]
		
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
