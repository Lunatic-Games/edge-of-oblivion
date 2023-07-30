@tool
class_name ItemData
extends Resource


const CARD_TEXT_EXPORT_PREFIX: String = "card_text_"
const POPUP_TEXT_EXPORT_PREFIX: String = "popup_text_"

@export var sprite: Texture2D = null
@export var item_scene: PackedScene = null
@export_placeholder("Item Name") var item_name: String = ""
@export_enum("red", "royalblue", "cyan", "springgreen", "white") var popup_item_name_color: String = "royalblue"
@export_multiline var flavor_text: String = ""

@export_range(1, 10, 1, "or_greater") var max_tier: int = 3:
	set = _set_max_tier
@export var use_tier_1_text_for_popup_texts: bool = false:
	set = _set_use_tier_1_text_for_popup_texts

var _card_texts: Dictionary = {}  # Property name : text
var _popup_texts: Dictionary = {}  # Property name : text


func get_card_text(tier: int) -> String:
	return _card_texts.get(CARD_TEXT_EXPORT_PREFIX + str(tier), "")


func get_popup_text(tier: int) -> String:
	var color_tag: String = "[color=" + Color(popup_item_name_color).to_html() + "]"
	var tier_info: String = "(" + "I".repeat(tier) + ")"
	var title: String = color_tag + item_name + tier_info + ":[/color] "
	
	# WIP: Simulation Testing
	var item_key = item_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED).name
	var item = GlobalGameState.get_tree().root.get_node('Game/TheEdge/Board/Player/CanvasLayer/Inventory/' + item_key)
	if item:
		var simulated_variables = get_simulated_variables(item)
		for key in simulated_variables:
			print("Item: " + item.name + " Current Tier: " + str(item.current_tier) + " " + key + ": " + str(item.get_node("LT_PersistentVariables/" + key).value))
			print("Item: " + item.name + " Next Tier: " + str(item.current_tier + 1) + " " + key + ": " + str(simulated_variables[key]))
	# END WIP
	
	if use_tier_1_text_for_popup_texts:
		return title + _card_texts.get(CARD_TEXT_EXPORT_PREFIX + str(1), "")
	return title + _popup_texts.get(POPUP_TEXT_EXPORT_PREFIX + str(tier), "")


func get_simulated_variables(item: Item) -> Dictionary:
	var result: Dictionary = {}
	item.simulate_tier_increase.emit()
	for variable in item.get_node("LT_PersistentVariables/").get_children():
		var name: String = variable.name
		var LT_variable: LogicTreeVariable = item.get_node("LT_PersistentVariables/" + name)
		if LT_variable:
			result[name] = LT_variable.last_simulated_value
	return result


func _set_max_tier(n: int) -> void:
	max_tier = n
	for i in max_tier:
		if _card_texts.has(CARD_TEXT_EXPORT_PREFIX + str(i + 1)) == false:
			_card_texts[CARD_TEXT_EXPORT_PREFIX + str(i + 1)] = "Default text"
		if _popup_texts.has(POPUP_TEXT_EXPORT_PREFIX + str(i + 1)) == false:
			_popup_texts[POPUP_TEXT_EXPORT_PREFIX + str(i + 1)] = "Default text"
	notify_property_list_changed()


func _set_use_tier_1_text_for_popup_texts(use_tier_1: bool) -> void:
	use_tier_1_text_for_popup_texts = use_tier_1
	notify_property_list_changed()


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		"name": "Card tier texts",
		"hint_string": CARD_TEXT_EXPORT_PREFIX,
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	for i in max_tier:
		properties.append({
			"name": CARD_TEXT_EXPORT_PREFIX + str(i + 1),
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_MULTILINE_TEXT,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	
	if use_tier_1_text_for_popup_texts == false:
		properties.append({
			"name": "Hover info texts",
			"hint_string": POPUP_TEXT_EXPORT_PREFIX,
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP
		})
		for i in max_tier:
			properties.append({
				"name": POPUP_TEXT_EXPORT_PREFIX + str(i + 1),
				"type": TYPE_STRING,
				"hint": PROPERTY_HINT_MULTILINE_TEXT,
				"usage": PROPERTY_USAGE_DEFAULT
			})
		
	return properties


func _get(property: StringName) -> Variant:
	if property.begins_with(CARD_TEXT_EXPORT_PREFIX) and _card_texts.has(property):
		return _card_texts[property]
	elif property.begins_with(POPUP_TEXT_EXPORT_PREFIX) and _popup_texts.has(property):
		return _popup_texts[property]
	
	return null


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with(CARD_TEXT_EXPORT_PREFIX):
		_card_texts[property] = value
	if property.begins_with(POPUP_TEXT_EXPORT_PREFIX):
		_popup_texts[property] = value
	
	return true
