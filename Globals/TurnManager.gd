extends Node

signal player_turn_ended

const FADED: PackedScene = preload("res://Data/Units/Enemies/Faded/Faded.tscn")
const LOST_RANGER: PackedScene = preload("res://Data/Units/Enemies/LostRanger/LostRanger.tscn")
const FORSWORN_PIKE: PackedScene = preload("res://Data/Units/Enemies/ForswornPike/ForswornPike.tscn")
const FORGOTTEN_KING: PackedScene = preload("res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")

var round_spawn_data: Dictionary = {
	2: [FADED],
	6: [FADED],
	12: [FADED],
	20: [FADED,FADED,FADED,FADED,FADED,FADED,FADED,FADED],
	26: [FADED],
	34: [FADED,],
	40: [FADED],
	44: [FADED],
	55: [LOST_RANGER,LOST_RANGER,LOST_RANGER,LOST_RANGER,LOST_RANGER,FADED,FADED,FADED,FADED,FADED],
	65: [FADED,LOST_RANGER,],
	75: [FADED, FADED],
	80: [FADED, LOST_RANGER],
	85: [LOST_RANGER, LOST_RANGER, FADED],
	90: [FADED],
	100: [FORSWORN_PIKE,FORSWORN_PIKE, FORSWORN_PIKE, FORSWORN_PIKE, FORSWORN_PIKE, FORSWORN_PIKE, FORSWORN_PIKE],
	105: [FORSWORN_PIKE],
	115: [FORSWORN_PIKE, FADED],
	125: [FADED, LOST_RANGER],
	135: [FORSWORN_PIKE],
	145: [FORSWORN_PIKE, LOST_RANGER, LOST_RANGER],
	150: [FORGOTTEN_KING],
	152: [FORSWORN_PIKE, FORSWORN_PIKE, FADED, FADED, LOST_RANGER],
	158: [FORSWORN_PIKE, LOST_RANGER, FADED],
	168: [LOST_RANGER, LOST_RANGER, LOST_RANGER, FORSWORN_PIKE, FORSWORN_PIKE],
	175: [FORSWORN_PIKE, FADED, LOST_RANGER]
}

var current_round: int = 0


func _ready() -> void:
	GlobalSignals.player_finished_moving.connect(_on_player_finished_moving)


func initialize() -> void:
	await GlobalSignals.game_started
	new_round()


func reset() -> void:
	current_round = 0


func new_round() -> void:
	current_round += 1
	GameManager.spawn_enemies()
	GameManager.calculate_spawn_location_for_next_round()


func _on_player_finished_moving(player: Player) -> void:
	for item in player.inventory.items.values():
		item.update()
	
	for tile in GameManager.board.all_tiles:
		tile.update()
	
	for enemy in GameManager.all_enemies:
		enemy.update()
	
	new_round()
	player.new_turn()
