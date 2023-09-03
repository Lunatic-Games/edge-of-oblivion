class_name Templator
extends Resource


# These will need to stay in sync with the match cases below 
#(in template_string_from_item)
const TIER_MODIFIERS: String = "(\\d+|CURRENT|NEXT|PREV)"
const FORGE_MODIFIERS: String = "(\\d+|CURRENT|NEXT|PREV)"


static func _get_item_variables(item: Item) -> Dictionary:
	var variables = {}
	
	# LT_TierableIntVariable
	variables['LT_TierableIntVariable'] = item.find_children("*", "LT_TierableIntVariable")
	
	return variables


static func get_available_templates(item: Item) -> Array[String]:
	var available_templates: Array[String] = []
	var variables: Dictionary = _get_item_variables(item)
	
	# LT_TierableIntVariable
	if (variables.has('LT_TierableIntVariable')):
		for tiv in variables['LT_TierableIntVariable']:
			available_templates.push_back("{{"+ tiv.name +":" + FORGE_MODIFIERS + ":" + TIER_MODIFIERS + "}}")
	
	return available_templates


static func template_string_from_item(item: Item, text: String) -> String:
	var variables: Dictionary = _get_item_variables(item)
	var output_text = text
	
	# LT_TierableIntVariable
	if (variables.has('LT_TierableIntVariable')):
		for tiv in variables['LT_TierableIntVariable']:
			assert(tiv is LT_TierableIntVariable, "Non LT_TierableIntVariable found")
			var pattern = "\\{\\{" + tiv.name + ":" + FORGE_MODIFIERS + ":" + TIER_MODIFIERS + "\\}\\}"
			var regex = RegEx.create_from_string(pattern)
			for m in regex.search_all(text):
				
				# Handle forge_level
				var forge_level: int = 0
				match m.get_string(1):
					"CURRENT": 
						forge_level = item.forge_level
					"NEXT":
						forge_level = item.forge_level + 1
					"PREV":
						forge_level = item.forge_level - 1
					_:
						forge_level = m.get_string(1).to_int()
				assert(forge_level > 0 and forge_level <= item.data.max_forge_level, "Forge Level requested out of bounds")

				# Handle forge_level
				var tier: int = 0
				match m.get_string(2):
					"CURRENT": 
						tier = item.current_tier
					"NEXT":
						tier = item.current_tier + 1
					"PREV":
						tier = item.current_tier - 1
					_:
						tier = m.get_string(2).to_int()
				assert(tier > 0 and tier <= item.data.max_tier, "Tier requested out of bounds")

				# Do the replacement
				var value = tiv.get_value_for_tier(forge_level, tier)
				output_text = output_text.replace(m.get_string(), str(value))

	return output_text		
