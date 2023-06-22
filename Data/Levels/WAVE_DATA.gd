@tool
class_name WaveData
extends Resource


@export_range(0, 99, 1, "or_greater") var turn_wait_from_previous_wave: int = 1

var possible_enemies: Dictionary  # readable name : enemy packed scene
var spawn_data: Dictionary # readable name : # to spawn


func _ready():
	possible_enemies.clear()


func update_possible_enemies(enemies: Array[PackedScene]):
	possible_enemies.clear()
	
	for enemy_scene in enemies:
		if enemy_scene == null:
			continue
		
		var root_name: String = enemy_scene.get_state().get_node_name(0)
		possible_enemies[root_name] = enemy_scene
		if not spawn_data.has(root_name):
			spawn_data[root_name] = 0
	notify_property_list_changed()


func _get_property_list() -> Array:
	var properties = []
	for enemy_name in possible_enemies:
		properties.append({
			"name": "# " + enemy_name,
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	return properties


func _get(property: StringName):
	property = property.trim_prefix("# ")
	if spawn_data.has(property):
		return spawn_data[property]


func _set(property: StringName, value) -> bool:
	property = property.trim_prefix("# ")
	if possible_enemies.has(property):
		if value < 0:
			print("Clearing " + str(property))
			return false
		
		print("Setting " + str(property) + " to " + str(value))
		spawn_data[property] = value
		notify_property_list_changed()
		return true
	return false
