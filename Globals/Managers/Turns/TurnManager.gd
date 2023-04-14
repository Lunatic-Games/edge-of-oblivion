extends Node

signal playerTurnEnded

const FADED = preload("res://Data/Units/Enemies/Faded/Faded.tscn")
const LOST_RANGER = preload("res://Data/Units/Enemies/LostRanger/LostRanger.tscn")
const FORSWORN_PIKE = preload("res://Data/Units/Enemies/ForswornPike/ForswornPike.tscn")
const FORGOTTEN_KING = preload("res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")

var roundSpawnData = {
	2: [FADED],
	6: [FADED],
	12: [FADED, FADED],
	20: [FADED],
	26: [FADED],
	34: [FADED, FADED],
	40: [FADED],
	44: [FADED],
	55: [LOST_RANGER, FADED],
	65: [LOST_RANGER, LOST_RANGER, LOST_RANGER],
	75: [FADED, FADED],
	80: [FADED, LOST_RANGER],
	85: [LOST_RANGER, LOST_RANGER, FADED],
	90: [FADED],
	100: [FORSWORN_PIKE],
	105: [FORSWORN_PIKE],
	115: [FORSWORN_PIKE, FORSWORN_PIKE, FORSWORN_PIKE, FORSWORN_PIKE],
	125: [FADED, LOST_RANGER],
	135: [FORSWORN_PIKE],
	145: [FORSWORN_PIKE, LOST_RANGER, LOST_RANGER],
	150: [FORGOTTEN_KING],
	152: [FORSWORN_PIKE, FORSWORN_PIKE, FADED, FADED, LOST_RANGER],
	158: [FORSWORN_PIKE, LOST_RANGER, FADED],
	168: [LOST_RANGER, LOST_RANGER, LOST_RANGER, FORSWORN_PIKE, FORSWORN_PIKE],
	175: [FORSWORN_PIKE, FADED, LOST_RANGER]
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
