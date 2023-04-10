extends "res://Items/Item.gd"

var heal_amount: int = 1

# Tiered cooldown: 
#	1: 9
#	2: 7
#	3: 5


func upgrade_tier() -> bool:
	var ret: bool = super.upgrade_tier()
	match currentTier:
		2:
			self.maxTurnTimer = 7
		3:
			self.maxTurnTimer = 5
	return ret


func activate_item() -> void:
	perform_heal()
	await get_tree().process_frame


func perform_heal() -> void:
	# Play animation
	heal()


func heal() -> void:
	user.heal(heal_amount)

