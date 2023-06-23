@tool
class_name LevelWaves
extends Node


@export var enemy_scenes: Array[PackedScene]:
	set = set_enemy_scenes
@export var waves: Array[WaveData]:
	set = set_waves

var spawns_for_turn: Dictionary  # turn number : [scenes]


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
		spawns_for_turn[i] = wave.get_enemy_scenes_for_wave()


func set_enemy_scenes(value: Array[PackedScene]) -> void:
	var unique_scenes: Array[PackedScene] = []
	for scene in value:
		if unique_scenes.has(scene) == false:
			unique_scenes.append(scene)
	
	enemy_scenes = []
	enemy_scenes.append_array(unique_scenes)
	
	for wave in waves:
		if wave:
			wave.update_enemy_scenes(enemy_scenes)


func set_waves(value: Array[WaveData]) -> void:
	waves = value
	for i in waves.size():
		if waves[i] == null:
			waves[i] = WaveData.new()
		waves[i].update_enemy_scenes(enemy_scenes)
