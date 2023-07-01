extends MenuDropdownButton


func setup():
	add_to_menu("Kill all enemies", kill_all_enemies)
	add_to_menu("Trigger victory screen", show_victory_screen)
	add_to_menu("Toggle fullscreen", toggle_fullscreen)


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
	
	GlobalGameState.game._on_Boss_defeated(Boss.new())


func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
