class_name Level
extends Node2D


@export var waves: Array[WaveData]

var spawns_for_turn: Dictionary  # turn number : [enemy scenes]
@onready var board: Board = $Board


func _ready() -> void:
	calculate_spawns_for_each_turn()


func get_enemies_for_turn(turn: int) -> Array[PackedScene]:
	var enemies: Array[PackedScene] = []
	enemies = spawns_for_turn.get(turn, enemies)
	return enemies


func calculate_spawns_for_each_turn() -> void:
	spawns_for_turn.clear()
	
	var i: int = 1  # Start after the first turn
	for wave in waves:
		i += wave.turn_wait_from_previous_wave
		spawns_for_turn[i] = wave.get_enemies_for_wave()
