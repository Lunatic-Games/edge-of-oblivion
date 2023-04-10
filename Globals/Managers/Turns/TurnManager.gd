extends Node

signal player_turn_ended

const FADED = preload("res://Data/Units/Enemies/Faded/Faded.tscn")
const LOST_RANGER = preload("res://Data/Units/Enemies/LostRanger/LostRanger.tscn")
const FORSWORN_PIKE = preload("res://Data/Units/Enemies/ForswornPike/ForswornPike.tscn")
const FORGOTTEN_KING = preload("res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")

var round_spawn_data = {
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

enum TurnState {ENEMY, PLAYER}
var current_turn_state = TurnState.PLAYER
var current_round = 0

func initialize():
	call_deferred("handle_round_update")

func reset():
	current_round = 0
	current_turn_state = TurnState.PLAYER

func is_player_turn():
	if current_turn_state == TurnState.PLAYER:
		return true
	return false

func item_phase_ended():
	start_enemy_turn()

func start_enemy_turn():
	current_turn_state = TurnState.ENEMY
	handle_enemy_turn()

func end_player_turn():
	emit_signal("player_turn_ended")

func start_player_turn():
	handle_round_update()
	current_turn_state = TurnState.PLAYER

func handle_enemy_turn():
	for enemy in GameManager.all_enemies:
		enemy.activate()
	
	start_player_turn()

func handle_round_update():
	current_round += 1
	GameManager.spawn_enemies()
	GameManager.calculate_spawn_location_for_next_round()
