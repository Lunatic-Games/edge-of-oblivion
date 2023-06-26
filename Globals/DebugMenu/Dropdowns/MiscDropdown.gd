extends MenuDropdownButton


func setup():
	add_to_menu("Kill all enemies", kill_all_enemies)
	add_to_menu("Trigger victory screen", show_victory_screen)


func kill_all_enemies():
	if GlobalGameState.game == null:
		return
	
	# Iterate backwards since elements are deleted as they die
	var enemies: Array[Enemy] = GlobalGameState.game.spawn_handler.spawned_enemies
	for i in range(enemies.size() - 1, -1, -1):
		enemies[i].take_damage(enemies[i].max_hp)


func show_victory_screen():
	if GlobalGameState.game == null:
		return
	
	GlobalGameState.game_ended = true
	GlobalGameState.game.upgrade_menu.hide()
	GlobalGameState.game.victory_screen.show()
