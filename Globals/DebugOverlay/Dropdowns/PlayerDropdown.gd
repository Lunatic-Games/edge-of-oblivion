extends MenuDropdownButton


func setup() -> void:
	add_to_menu("Level up", level_up)
	add_to_menu("Damage player", damage_player)
	add_to_menu("Kill player", kill_player)
	add_to_menu("Heal player", partially_heal_player)
	add_to_menu("Fully heal player", fully_heal_player)
	add_to_menu("Teleport player", teleport_player)


func level_up() -> void:
	if GlobalGameState.player == null:
		return
	
	GlobalGameState.player.level_up()
	GlobalGameState.game.check_for_upgrades()


func damage_player() -> void:
	if GlobalGameState.player == null:
		return
	
	var max_health: int = GlobalGameState.player.health.data.max_health
	var damage_amount: int = int(max_health / 4.0)
	GlobalGameState.player.health.take_damage(damage_amount)


func partially_heal_player() -> void:
	if GlobalGameState.player == null:
		return
	
	var max_health: int = GlobalGameState.player.health.data.max_health
	var heal_amount: int = int(max_health / 4.0) 
	GlobalGameState.player.health.heal(heal_amount)


func fully_heal_player() -> void:
	if GlobalGameState.player == null:
		return
	
	GlobalGameState.player.health.full_heal()


func kill_player() -> void:
	if GlobalGameState.player == null:
		return
	
	GlobalGameState.player.health.deal_lethal_damage()


func teleport_player() -> void:
	GlobalDebugOverlay.select_tiles_menu.begin_selection(_teleport_player_to_tile,
		"Select Empty Tile")


func _teleport_player_to_tile(tile: Tile):
	if tile == null or GlobalGameState.player == null:
		return
	
	if tile.occupant != null and !tile.occupant.occupancy.data.is_collectable():
		return
	
	GlobalGameState.player.occupancy.move_to_tile(tile)
