class_name GameMode
extends RefCounted


var game: Game = null
var player: Player = null
var data: GameModeData = null

var current_round: int = 1
var is_round_processing: bool = false


func _init(p_game: Game, game_mode_data: GameModeData) -> void:
	game = p_game
	data = game_mode_data
	
	GlobalSignals.boss_defeated.connect(_on_boss_defeated)
	game.upgrade_menu.closed.connect(_on_upgrade_menu_closed)
	
	var existing_player: Player = GlobalGameState.get_player()
	# If the player is set to persist then they will still be valid
	# If they aren't then they will be queued for being freed and be invalid
	if is_instance_valid(existing_player):
		player = game.spawn_handler.spawn_existing_player(existing_player)
	else:
		player = game.spawn_handler.spawn_player()
	
	player.health.died.connect(_on_player_died)
	player.levelling.levelled_up.connect(_on_player_levelled_up)
	
	_spawn_flags_for_next_round()
	
	var level_data: LevelData = game.level_data
	if level_data.gateway_spawn_condition == LevelData.GatewaySpawnCondition.ON_LOAD:
		if level_data.next_level:
			game.spawn_handler.spawn_gateway(level_data.next_level)


func update():
	if is_round_processing or is_instance_valid(player) == false:
		return
	
	player.input_controller.check_for_input(data.get_total_process_time())
	if player.input_controller.are_moves_all_used() == false:
		return
	
	process_round()


func process_round() -> void:
	var scene_tree: SceneTree = game.get_tree()
	is_round_processing = true
	
	await scene_tree.create_timer(data.move_phase_duration_seconds).timeout
	
	if data.update_items:
		for item in player.inventory.items.values():
			item.update()
	
	await scene_tree.create_timer(data.item_phase_duration_seconds).timeout
	
	for tile in game.level.board.all_tiles:
		tile.update()
	
	await scene_tree.create_timer(data.tile_phase_duration_seconds).timeout
	
	for enemy in game.spawn_handler.spawned_enemies:
		enemy.update()
	
	await scene_tree.create_timer(data.enemy_phase_duration_seconds).timeout
	
	if data.increment_round_number:
		current_round += 1
	
	_spawn_enemies_for_round()
	check_for_gateway_spawning_this_round()
	await scene_tree.create_timer(data.enemy_spawn_phase_duration_seconds).timeout
	
	_spawn_flags_for_next_round()
	await scene_tree.create_timer(data.spawn_flag_phase_duration_seconds).timeout
	
	var levelled_up: bool = game.check_for_upgrades()
	if levelled_up == false and is_instance_valid(player) and player.health.is_alive():
		game.check_for_level_transition()
	
	if is_instance_valid(player):  # If they died or something since their turn
		player.input_controller.reset_moves_remaining()
	
	is_round_processing = false


func check_for_gateway_spawning_this_round() -> void:
	var level_data: LevelData = game.level_data
	if level_data.gateway_spawn_condition != LevelData.GatewaySpawnCondition.LAST_WAVE_SPAWNED:
		return
	
	if current_round == level_data.level_waves.round_of_last_wave and level_data.next_level:
		game.spawn_handler.spawn_gateway(level_data.next_level)


func _spawn_enemies_for_round() -> void:
	var waves_data: LevelWaves = game.level.data.level_waves
	if waves_data == null:
		return
	
	var enemies_to_spawn: Array[EnemyData] = waves_data.get_enemies_for_round(current_round)
	game.spawn_handler.spawn_enemies(enemies_to_spawn)


func _spawn_flags_for_next_round() -> void:
	var waves_data: LevelWaves = game.level.data.level_waves
	if waves_data == null:
		return
	
	var next_round: int = current_round + 1
	var n_enemies_next_turn: int = waves_data.get_enemies_for_round(next_round).size()
	game.spawn_handler.spawn_flags_for_next_turn(n_enemies_next_turn)


func _on_player_died(_player: Player) -> void:
	game.game_over()


func _on_player_levelled_up(_player_level: int):
	game.upgrade_menu.queue_upgrade()


func _on_boss_defeated(_boss: Enemy) -> void:
	var level_data: LevelData = game.level_data
	
	if level_data.killing_boss_completes_run:
		game.victory()
	
	elif level_data.gateway_spawn_condition == LevelData.GatewaySpawnCondition.BOSS_DEFEATED:
		if level_data.next_level:
			game.spawn_handler.spawn_gateway(level_data.next_level)


func _on_upgrade_menu_closed() -> void:
	game.check_for_level_transition()
