extends MenuDropdownButton


func setup() -> void:
	add_to_menu("Level up", level_up)
	add_to_menu("Damage player", damage_player)
	add_to_menu("Kill player", kill_player)
	add_to_menu("Heal player", partially_heal_player)
	add_to_menu("Fully heal player", fully_heal_player)


func level_up() -> void:
	if GlobalGameState.player == null:
		return
	
	GlobalGameState.player.level_up()


func damage_player() -> void:
	if GlobalGameState.player == null:
		return
	
	var max_health: int = GlobalGameState.player.max_hp
	var damage_amount: int = int(max_health / 4.0)
	GlobalGameState.player.take_damage(damage_amount)


func partially_heal_player() -> void:
	if GlobalGameState.player == null:
		return
	
	var max_health: int = GlobalGameState.player.max_hp
	var heal_amount: int = int(max_health / 4.0) 
	GlobalGameState.player.heal(heal_amount)


func fully_heal_player() -> void:
	if GlobalGameState.player == null:
		return
	
	var max_health: int = GlobalGameState.player.max_hp
	# Make sure it's not negative and that it's a non-zero heal (for vfx to trigger)
	var heal_amount: int = max(1, max_health - GlobalGameState.player.hp)
	GlobalGameState.player.heal(heal_amount)


func kill_player() -> void:
	if GlobalGameState.player == null:
		return
	
	var current_health: int = GlobalGameState.player.hp
	GlobalGameState.player.take_damage(current_health)
