extends MenuDropdownButton


func setup() -> void:
	add_to_menu("Level up", level_up)
	add_to_menu("Damage player", damage_player)
	add_to_menu("Kill player", kill_player)
	add_to_menu("Heal player", partially_heal_player)
	add_to_menu("Fully heal player", fully_heal_player)
	add_to_menu("Teleport player", teleport_player)
	add_to_menu("Update items", update_items)
	add_to_menu("Add Gold (50)", add_gold)


func level_up() -> void:
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	player.levelling.level_up()
	
	var game: Game = GlobalGameState.get_game()
	game.check_for_upgrades()


func damage_player() -> void:
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	var max_health: int = player.health.data.max_health
	var damage_amount: int = int(max_health / 4.0)
	player.health.take_damage(damage_amount)


func partially_heal_player() -> void:
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	var max_health: int = player.health.data.max_health
	var heal_amount: int = int(max_health / 4.0) 
	player.health.heal(heal_amount)


func fully_heal_player() -> void:
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	player.health.full_heal()


func kill_player() -> void:
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	player.health.deal_lethal_damage()


func teleport_player() -> void:
	GlobalDebugOverlay.select_tiles_menu.begin_selection(_teleport_player_to_tile,
		"Select Empty Tile")


func _teleport_player_to_tile(tile: Tile):
	var player: Player = GlobalGameState.get_player()
	if tile == null or player == null:
		return
	
	var player_data: PlayerData = player.data as PlayerData
	
	if tile.occupant != null and !tile.occupant.occupancy.data.can_be_collected(player_data):
		return
	
	player.occupancy.move_to_tile(tile)


func update_items():
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	for item in player.inventory.items.values():
		item.update()


func add_gold():
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	player.inventory.add_gold(50)
