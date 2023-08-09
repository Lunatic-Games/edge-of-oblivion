class_name RoundManager
extends Object


var game: Game = null
var player: Player = null
var game_mode_data: GameModeData = null
var current_round: int = 1
var is_round_processing: bool = false


func _init(p_game: Game, mode_data: GameModeData) -> void:
	game = p_game
	player = game.player
	game_mode_data = mode_data


func update():
	if is_round_processing:
		return
	
	player.input_controller.check_for_input(game_mode_data.get_total_process_time())
	if player.input_controller.are_moves_all_used() == false:
		return
	
	process_round()


func process_round() -> void:
	var scene_tree: SceneTree = game.get_tree()
	is_round_processing = true
	
	await scene_tree.create_timer(game_mode_data.move_phase_duration_seconds).timeout
	
	if game_mode_data.update_items:
		for item in player.inventory.items.values():
			item.update()
	
	await scene_tree.create_timer(game_mode_data.item_phase_duration_seconds).timeout
	
	for tile in game.level.board.all_tiles:
		tile.update()
	
	await scene_tree.create_timer(game_mode_data.tile_phase_duration_seconds).timeout
	
	for enemy in game.spawn_handler.spawned_enemies:
		enemy.update()
	
	await scene_tree.create_timer(game_mode_data.enemy_phase_duration_seconds).timeout
	
	if game_mode_data.increment_round_number:
		current_round += 1
	
	game.spawn_enemies_for_round()
	await scene_tree.create_timer(game_mode_data.enemy_spawn_phase_duration_seconds).timeout
	
	game.spawn_flags_for_next_round()
	await scene_tree.create_timer(game_mode_data.spawn_flag_phase_duration_seconds).timeout
	
	game.check_for_upgrades()
	game.check_for_level_transition()
	
	if is_instance_valid(player):  # If they died or something since their turn
		player.input_controller.reset_moves_remaining()
	
	is_round_processing = false
