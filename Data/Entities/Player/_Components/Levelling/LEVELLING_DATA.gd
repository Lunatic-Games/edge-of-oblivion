@tool
class_name LevellingData
extends Resource


const XP_EXPORT_PREFIX: String = "xp_level_"

@export_range(1, 10, 1, "or_greater") var max_level: int = 10:
	set = set_max_level

var xp_to_level: Dictionary = {}  # Property name : Int


func set_max_level(level: int) -> void:
	max_level = level
	notify_property_list_changed()


func get_xp_to_level(level: int) -> int:
	return xp_to_level.get(XP_EXPORT_PREFIX + str(level), -1)


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		"name": "XP to level",
		"hint_string": XP_EXPORT_PREFIX,
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	})
	for i in max_level - 1:
		properties.append({
			"name": XP_EXPORT_PREFIX + str(i+2),
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	
	return properties


func _get(property: StringName) -> Variant:
	if property.begins_with(XP_EXPORT_PREFIX):
		if xp_to_level.has(property):
			return xp_to_level[property]
		else:
			return 1
	
	return null


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with(XP_EXPORT_PREFIX) and value > 0:
		xp_to_level[property] = value
	
	return true
