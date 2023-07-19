@tool
class_name LevelWaves
extends Node


@export var enemies: Array[EnemyData]:
	set = set_enemies
@export var waves: Array[WaveData]:
	set = set_waves

var spawns_for_turn: Dictionary  # turn number : [scenes]


func _ready() -> void:
	calculate_spawns_for_each_turn()


func get_enemies_for_turn(turn: int) -> Array[EnemyData]:
	var enemies_for_turn: Array[EnemyData] = []
	enemies_for_turn = spawns_for_turn.get(turn, enemies_for_turn)
	return enemies_for_turn


func calculate_spawns_for_each_turn() -> void:
	spawns_for_turn.clear()
	
	var i: int = 1  # Start after the first turn
	for wave in waves:
		i += wave.turn_wait_from_previous_wave
		spawns_for_turn[i] = wave.get_enemies_for_wave()
		wave.update_round_info(i)


func set_enemies(value: Array[EnemyData]) -> void:
	var unique_scenes: Array[EnemyData] = []
	for scene in value:
		if unique_scenes.has(scene) == false:
			unique_scenes.append(scene)
	
	enemies = []
	enemies.append_array(unique_scenes)
	
	for wave in waves:
		if wave:
			wave.update_enemies(enemies)


func set_waves(value: Array[WaveData]) -> void:
	waves = value
	for i in waves.size():
		if waves[i] == null:
			waves[i] = WaveData.new()
		
		var wave: WaveData = waves[i]
		wave.update_available_enemies(enemies)
		
		if !wave.turn_wait_value_changed.is_connected(_on_wave_turn_wait_value_changed):
			wave.turn_wait_value_changed.connect(_on_wave_turn_wait_value_changed)
	calculate_spawns_for_each_turn()


func _on_wave_turn_wait_value_changed():
	calculate_spawns_for_each_turn()
