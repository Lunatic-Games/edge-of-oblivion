class_name GameMode
extends Object


var game: Game = null
var player: Player = null
var data: GameModeData = null

var current_round: int = 1
var is_round_processing: bool = false


func _init(p_game: Game, game_mode_data: GameModeData) -> void:
	game = p_game
	player = game.player
	data = game_mode_data
	_spawn_flags_for_next_round()


func update():
	if is_round_processing or is_instance_valid(player) == false:
		return
	
	if player.health.is_alive() == false:
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
	await scene_tree.create_timer(data.enemy_spawn_phase_duration_seconds).timeout
	
	_spawn_flags_for_next_round()
	await scene_tree.create_timer(data.spawn_flag_phase_duration_seconds).timeout
	
	var levelled_up: bool = game.check_for_upgrades()
	if levelled_up == false and is_instance_valid(player) and player.health.is_alive():
		game.check_for_level_transition()
	
	if is_instance_valid(player):  # If they died or something since their turn
		player.input_controller.reset_moves_remaining()
	
	is_round_processing = false


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
