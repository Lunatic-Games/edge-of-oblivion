extends MenuDropdownButton


func setup():
	add_to_menu("Trigger victory screen", show_victory_screen)
	add_to_menu("Toggle fullscreen", toggle_fullscreen)


func show_victory_screen():
	if GlobalGameState.game == null:
		return
	
	GlobalGameState.game._on_Boss_defeated(Enemy.new())


func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
