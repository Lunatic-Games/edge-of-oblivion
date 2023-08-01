extends MenuDropdownButton


func setup() -> void:
	add_to_menu("Kill target enemies", target_kill)
	add_to_menu("Update target enemies", target_update)
	add_to_menu("Kill all enemies", kill_all)


func target_kill() -> void:
	GlobalDebugOverlay.select_tiles_menu.begin_selection(_kill_enemy_on_tile, "Select Enemies to Kill")
	

func target_update() -> void:
	GlobalDebugOverlay.select_tiles_menu.begin_selection(_update_enemy_on_tile, "Select Enemies to Update")


func kill_all() -> void:
	if GlobalGameState.game == null:
		return
	
	# Iterate backwards since elements are deleted as they die
	var enemies: Array[Enemy] = GlobalGameState.game.spawn_handler.spawned_enemies
	for i in range(enemies.size() - 1, -1, -1):
		enemies[i].debug_kill()


func _kill_enemy_on_tile(tile: Tile):
	if tile == null or tile.occupant == null:
		return
	
	var enemy: Enemy = tile.occupant as Enemy
	if enemy == null:
		return
	
	enemy.debug_kill()


func _update_enemy_on_tile(tile: Tile):
	if tile == null or tile.occupant == null:
		return
	
	var enemy: Enemy = tile.occupant as Enemy
	if enemy == null:
		return

	enemy.update()
