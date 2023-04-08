extends "res://Items/Item.gd"


var heal_amount: int = 1

# Tiered cooldown: 
#	1: 9
#	2: 7
#	3: 5

func upgradeTier() -> bool:
	var ret: bool = .upgradeTier()
	match currentTier:
		2:
			self.maxTurnTimer = 7
		3:
			self.maxTurnTimer = 5
	return ret

func activateItem() -> void:
	perform_heal()
	yield(get_tree(), "idle_frame")

func perform_heal() -> void:
	# Play animation
	heal()

func heal() -> void:
	user.heal(heal_amount)

