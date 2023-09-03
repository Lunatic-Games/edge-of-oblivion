# NOTE: There is an invarient for this Node to work at that is that
#       there must exist an {ITEM}.tres file (based on ITEM_DATE) in 
#       the same folder as the {ITEM}.tscn file. Otherwise, bad stuff
#       will follow.
@tool
@icon("res://Assets/art/logic-tree/variables/n-tier.png")
class_name LT_TierableIntVariable
extends LT_IntVariable


const FORGE_VALUE_EXPORT_PREFIX: String = "forge_"
const TIER_VALUE_EXPORT_PREFIX: String = "_tier_"

var _tier_values: Dictionary = {}
var max_tier = 1
var max_forge = 1

func _ready():
	super._ready()
	var this_item: Item = owner as Item
	assert(this_item != null, "Owner is not an item for node: '" + name + "'")
	this_item.tier_increased.connect(_on_tier_increased.bind(this_item))


func _get_property_list() -> Array[Dictionary]:
	
	# This is where that very important invariant comes into play
	var item_data = load(owner.scene_file_path.replace("tscn", "tres")) as ItemData
	assert(item_data != null, "Unable to find tres file for '" + owner.name + "'")
	max_tier = item_data.max_tier
	max_forge = item_data.max_forge_level
	
	var properties: Array[Dictionary] = []
	for i in max_forge:
		properties.append({
			"name": "Forge Level " + str(i + 1),
			"hint_string": FORGE_VALUE_EXPORT_PREFIX + str(i + 1),
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP
		})
		for j in max_tier:
			properties.append({
				"name": FORGE_VALUE_EXPORT_PREFIX + str(i + 1) + TIER_VALUE_EXPORT_PREFIX + str(j + 1),
				"type": TYPE_INT,
				"usage": PROPERTY_USAGE_DEFAULT
			})
	
	return properties


func _get(property: StringName) -> Variant:
	if property.begins_with(FORGE_VALUE_EXPORT_PREFIX) and property.contains(TIER_VALUE_EXPORT_PREFIX) and _tier_values.has(property):
		return _tier_values[property]
	
	return null


func _set(property: StringName, n: Variant) -> bool:
	if property.begins_with(FORGE_VALUE_EXPORT_PREFIX) and property.contains(TIER_VALUE_EXPORT_PREFIX):
		_tier_values[property] = n
		if (property == FORGE_VALUE_EXPORT_PREFIX + "1" + TIER_VALUE_EXPORT_PREFIX + "1"):
			default_value = n
		return true
	
	return false


func _on_tier_increased(item: Item) -> void:
	value = _tier_values[FORGE_VALUE_EXPORT_PREFIX + str(item.forge_level) + TIER_VALUE_EXPORT_PREFIX + str(item.current_tier)]
	

func get_value_for_tier(forge: int, tier: int) -> int:
	return _tier_values[FORGE_VALUE_EXPORT_PREFIX + str(forge) + TIER_VALUE_EXPORT_PREFIX + str(tier)]
	
