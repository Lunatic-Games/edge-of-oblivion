extends MenuDropdownButton


func setup():
	add_to_menu("Trigger victory screen", show_victory_screen)
	add_to_menu("Toggle fullscreen", toggle_fullscreen)
	add_to_menu("Trigger gateway", spawn_gateway)


func show_victory_screen():
	var game: Game = GlobalGameState.get_game()
	if game == null:
		return
	
	game.victory()


func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func spawn_gateway():
	var game: Game = GlobalGameState.get_game()
	if game == null:
		return
	
	var level_data: LevelData = game.level_data
	if level_data == null:
		return
	
	var next_level_data: LevelData = level_data.next_level
	if next_level_data == null:
		print("Won't spawn a gateway since there isn't a next level set")
		return
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	if spawn_handler != null:
		spawn_handler.spawn_gateway(next_level_data)
