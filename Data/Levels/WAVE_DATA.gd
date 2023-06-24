@tool
class_name WaveData
extends Resource

signal turn_wait_value_changed

@export_range(1, 99, 1, "or_greater") var turn_wait_from_previous_wave: int = 1:
	set = set_turn_wait

var _absolute_round: int = 0  # Needs to be told from whatever manages waves
var _enemy_scenes: Dictionary  # export variable name : packed scene
var _spawn_data: Dictionary  # export variable name : number of spawns


func update_enemy_scenes(scenes: Array[PackedScene]) -> void:
	_enemy_scenes.clear()
	
	for scene in scenes:
		if scene == null:
			continue
		
		var root_name: String = scene.get_state().get_node_name(0)
		var export_name: String = "# " + root_name
		_enemy_scenes[export_name] = scene
		
		if not _spawn_data.has(export_name):
			_spawn_data[export_name] = 0
		
	notify_property_list_changed()


func set_turn_wait(value: int):
	var value_before: int = turn_wait_from_previous_wave
	turn_wait_from_previous_wave = value
	if turn_wait_from_previous_wave != value_before:
		turn_wait_value_changed.emit()


func update_round_info(wave_round: int):
	_absolute_round = wave_round
	notify_property_list_changed()


func get_enemy_scenes_for_wave() -> Array[PackedScene]:
	var scenes: Array[PackedScene] = []
	
	for export_name in _spawn_data:
		var packed_scene: PackedScene = _enemy_scenes[export_name]

		for i in _spawn_data[export_name]:
			scenes.append(packed_scene)
			
	return scenes


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for export_name in _enemy_scenes:
		properties.append({
			"name": export_name,
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	
	var n_scenes = get_enemy_scenes_for_wave().size()
	properties.append({
		"name": str(n_scenes) + " enemies at round " + str(_absolute_round),
		"hint_string": "info_",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	})
	properties.append({
		"name": "info_ ",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT
	})
	
	return properties


func _get(property: StringName) -> Variant:
	if property.begins_with("# "):
		return _spawn_data.get(property, null)
	return null


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("# "):
		if value < 0:
			return false
		
		_spawn_data[property] = value
	notify_property_list_changed()
	return true