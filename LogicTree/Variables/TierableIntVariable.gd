@tool
@icon("res://Assets/art/logic-tree/variables/n.png")
class_name LT_TierableIntVariable
extends LT_IntVariable


const TIER_VALUE_EXPORT_PREFIX: String = "tier_"

var _tier_values: Dictionary = {}
var max_tier = 1

func _ready():
	super._ready()
	var this_item: Item = owner as Item
#	this_item.setup_completed.connect(set_current_value_for_item.bind(this_item))
	this_item.tier_increased.connect(set_current_value_for_item.bind(this_item))

func _get_property_list() -> Array[Dictionary]:
	
	var item_data = load(owner.scene_file_path.replace("tscn", "tres")) as ItemData
	max_tier = item_data.max_tier
	
	var properties: Array[Dictionary] = []
	properties.append({
		"name": name + " Tiered Values",
		"hint_string": TIER_VALUE_EXPORT_PREFIX,
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	
	for i in max_tier:
		properties.append({
			"name": TIER_VALUE_EXPORT_PREFIX + str(i + 1),
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	
	return properties


func _get(property: StringName) -> Variant:
	if property.begins_with(TIER_VALUE_EXPORT_PREFIX) and _tier_values.has(property):
		return _tier_values[property]
	
	return null


func _set(property: StringName, n: Variant) -> bool:
	if property.begins_with(TIER_VALUE_EXPORT_PREFIX):
		_tier_values[property] = n
		if (property == TIER_VALUE_EXPORT_PREFIX + "1"):
			default_value = n
	
	return true


func get_value(tier: int) -> int:
	return _tier_values[TIER_VALUE_EXPORT_PREFIX + str(tier)]


func set_current_value(tier: int) -> void:
	value = _tier_values[TIER_VALUE_EXPORT_PREFIX + str(tier)]
	

func get_value_for_item(item: Item) -> int:
	return get_value(item.current_tier - 1)
	
	
func set_current_value_for_item(item: Item) -> void:
	set_current_value(item.current_tier)

