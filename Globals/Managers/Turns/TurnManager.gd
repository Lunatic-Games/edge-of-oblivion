extends Node

signal player_turn_ended

enum TurnState {ENEMY, PLAYER}

const FADED: PackedScene = preload("res://Data/Units/Enemies/Faded/Faded.tscn")
const LOST_RANGER: PackedScene = preload("res://Data/Units/Enemies/LostRanger/LostRanger.tscn")
const FORSWORN_PIKE: PackedScene = preload("res://Data/Units/Enemies/ForswornPike/ForswornPike.tscn")
const FORGOTTEN_KING: PackedScene = preload("res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")

var round_spawn_data: Dictionary = {
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

var current_turn_state: TurnState = TurnState.PLAYER
var current_round: int = 0


func initialize() -> void:
	call_deferred("handle_round_update")


func reset() -> void:
	current_round = 0
	current_turn_state = TurnState.PLAYER


func is_player_turn() -> bool:
	return current_turn_state == TurnState.PLAYER


func item_phase_ended() -> void:
	update_tiles()
	start_enemy_turn()


func start_enemy_turn() -> void:
	current_turn_state = TurnState.ENEMY
	handle_enemy_turn()


func end_player_turn() -> void:
	emit_signal("player_turn_ended")


func start_player_turn() -> void:
	handle_round_update()
	current_turn_state = TurnState.PLAYER


func update_tiles() -> void:
	for tile in GameManager.all_tiles:
		tile.update()


func handle_enemy_turn() -> void:
	for enemy in GameManager.all_enemies:
		enemy.update()
	
	start_player_turn()


func handle_round_update() -> void:
	current_round += 1
	GameManager.spawn_enemies()
	GameManager.calculate_spawn_location_for_next_round()
