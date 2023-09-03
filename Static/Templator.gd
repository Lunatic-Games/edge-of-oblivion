class_name Templator
extends Node


const LT_TIERABLEINTVARIABLES_MODIFIERS: String = "(:T[\\+-]?\\d+|:F[\\+-]?\\d+){0,2}"


static func _get_item_variables(item: Item) -> Dictionary:
	var variables = {}
	
	# LT_TierableIntVariable
	variables['LT_TierableIntVariable'] = item.find_children("*", "LT_TierableIntVariable")
	
	# LT_TierableIntVariable
	variables['LT_IntVariable'] = item.find_children("*", "LT_IntVariable")
	
	return variables


static func template_string_from_item(item: Item, text: String) -> String:
	var variables: Dictionary = _get_item_variables(item)
	var output_text = text
	
	# LT_IntVariable
	for iv in variables['LT_IntVariable']:
		assert(iv is LT_IntVariable, "Non LT_IntVariable found")
		var pattern = "\\{\\{" + iv.name + "\\}\\}"
		var regex = RegEx.create_from_string(pattern)
		for m in regex.search_all(text):
			# This is a kludgy check to see if the item has been instantiated just for the initial card templating
			var value = iv.value if (iv.value != 0 or item.current_tier > 1 or item.forge_level > 1) else iv.default_value
			output_text = output_text.replace(m.get_string(), str(value))
			
		
	# LT_TierableIntVariable
	for tiv in variables['LT_TierableIntVariable']:
		assert(tiv is LT_TierableIntVariable, "Non LT_TierableIntVariable found")
		var pattern = "\\{\\{" + tiv.name + LT_TIERABLEINTVARIABLES_MODIFIERS + "\\}\\}"
		var regex = RegEx.create_from_string(pattern)
		for m in regex.search_all(text):
			# Handle forge_level
			var forge_level: int = item.forge_level
			var forge_regex = RegEx.create_from_string(":F([\\+-])?(\\d+)")
			var forge_match = forge_regex.search(m.get_string())
			if forge_match:
				if forge_match.get_string(1) == "+":
					# Relative addition
					forge_level = item.forge_level + forge_match.get_string(2).to_int()
				elif forge_match.get_string(1) == "-":
					# Relative subtraction
					forge_level = item.forge_level - forge_match.get_string(2).to_int()
				else:
					# Absolute forge level
					forge_level = forge_match.get_string(2).to_int()
				assert(forge_level > 0 and forge_level <= item.data.max_forge_level, "Forge Level requested out of bounds")

			# Handle tier
			var tier: int = item.current_tier
			var tier_regex = RegEx.create_from_string(":T([\\+-])?(\\d+)")
			var tier_match = tier_regex.search(m.get_string())
			if tier_match:
				if tier_match.get_string(1) == "+":
					# Relative addition
					tier = item.current_tier + tier_match.get_string(2).to_int()
				elif tier_match.get_string(1) == "-":
					# Relative subtraction
					tier = item.current_tier - tier_match.get_string(2).to_int()
				else:
					# Absolute tier
					tier = tier_match.get_string(2).to_int()
				assert(tier > 0 and tier <= item.data.max_tier, "Tier requested out of bounds")

			# Do the replacement
			var value = tiv.get_value_for_tier(forge_level, tier)
			output_text = output_text.replace(m.get_string(), str(value))

	return output_text		
