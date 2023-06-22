@tool
class_name Level
extends Node2D


@export var possible_enemies: Array[PackedScene]:
	set = set_possible_enemies

@export var waves: Array[WaveData]:
	set = set_waves


var spawns_for_turn: Dictionary  # turn number : [enemy scenes]
@onready var board: Board = $Board


func _ready() -> void:
	calculate_spawns_for_each_turn()


func set_possible_enemies(enemies):
	possible_enemies = enemies
	for wave in waves:
		wave.update_possible_enemies(possible_enemies)


func set_waves(ws):
	waves = ws
	for wave in waves:
		if wave:
			wave.update_possible_enemies(possible_enemies)


func get_enemies_for_turn(turn: int) -> Array[PackedScene]:
	var enemies: Array[PackedScene] = []
	enemies = spawns_for_turn.get(turn, enemies)
	return enemies


func calculate_spawns_for_each_turn() -> void:
	spawns_for_turn.clear()
	
	var i: int = 0
	for wave in waves:
		i += wave.turn_wait_from_previous_wave
		
		var enemies: Array[PackedScene] = []
		for enemy_scene in wave.spawn_data:
			for _x in wave.spawn_data[enemy_scene]:
				enemies.push_back(enemy_scene)
		
		spawns_for_turn[i] = enemies
