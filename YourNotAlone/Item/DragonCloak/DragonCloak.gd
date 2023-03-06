extends "res://Item/Item.gd"


var damage_amount: int = 1

# Tiered cooldown: 
#	1: 6
#	2: 5
#	3: 4

func upgradeTier() -> bool:
	var ret: bool = .upgradeTier()
	match currentTier:
		2:
			self.maxTurnTimer = 5
		3:
			self.maxTurnTimer = 4
	return ret

func activateItem() -> void:
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack() -> void:
	var targets: Array = []

	#Scan all applicable tiles for valid targets, append each into targets

	attack(targets)
	$AnimationPlayer.play("Shake")

func attack(targets: Array) -> void:
	# Iterate through array and deal damage to each target
	pass

