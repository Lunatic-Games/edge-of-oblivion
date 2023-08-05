@tool
class_name LevelWaves
extends Resource


@export var enemies: Array[EnemyData]:
	set = set_enemies
@export var waves: Array[WaveData]:
	set = set_waves

var spawns_for_round: Dictionary  # round number : [scenes]


func _ready() -> void:
	calculate_spawns_for_each_round()


func get_enemies_for_round(p_round: int) -> Array[EnemyData]:
	var enemies_for_round: Array[EnemyData] = []
	enemies_for_round = spawns_for_round.get(p_round, enemies_for_round)
	return enemies_for_round


func calculate_spawns_for_each_round() -> void:
	spawns_for_round.clear()
	
	var i: int = 1  # Start after the first turn
	for wave in waves:
		i += wave.round_wait_from_previous_wave
		spawns_for_round[i] = wave.get_enemies_for_wave()
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
			wave.update_available_enemies(enemies)


func set_waves(value: Array[WaveData]) -> void:
	waves = value
	for i in waves.size():
		if waves[i] == null:
			waves[i] = WaveData.new()
		
		var wave: WaveData = waves[i]
		wave.update_available_enemies(enemies)
		
		if !wave.round_wait_value_changed.is_connected(_on_wave_round_wait_value_changed):
			wave.round_wait_value_changed.connect(_on_wave_round_wait_value_changed)
	calculate_spawns_for_each_round()


func _on_wave_round_wait_value_changed():
	calculate_spawns_for_each_round()
