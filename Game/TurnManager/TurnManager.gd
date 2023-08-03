class_name TurnManager
extends Object


const DELAY_AFTER_MOVING: float = 0.05
const DELAY_AFTER_ITEMS: float = 0.15
const DELAY_AFTER_TILES: float = 0.0
const DELAY_AFTER_ENEMIES: float = 0.15
const DELAY_AFTER_ENEMY_SPAWN: float = 0.1
const DELAY_AFTER_FLAG_SPAWN: float = 0.1

var current_round: int = 1
var is_turn_processing: bool = false


func update(player: Player, game: Game):
	if is_turn_processing:
		return
	
	player.input_controller.check_for_input()
	if player.input_controller.are_moves_all_used():
		on_player_finished_moving(player, game)


func on_player_finished_moving(player: Player, game: Game) -> void:
	var scene_tree: SceneTree = game.get_tree()
	is_turn_processing = true
	
	await scene_tree.create_timer(DELAY_AFTER_MOVING).timeout
	for item in player.inventory.items.values():
		item.update()
	
	await scene_tree.create_timer(DELAY_AFTER_ITEMS).timeout
	
	for tile in game.level.board.all_tiles:
		tile.update()
	
	await scene_tree.create_timer(DELAY_AFTER_TILES).timeout
	
	GlobalSignals.enemy_turn_started.emit()
	for enemy in game.spawn_handler.spawned_enemies:
		enemy.update()
	
	await scene_tree.create_timer(DELAY_AFTER_ENEMIES).timeout
	
	current_round += 1
	game.spawn_enemies_for_round()
	await scene_tree.create_timer(DELAY_AFTER_ENEMY_SPAWN).timeout
	
	game.spawn_flags_for_next_round()
	await scene_tree.create_timer(DELAY_AFTER_FLAG_SPAWN).timeout
	
	game.check_for_upgrades()
	
	if is_instance_valid(player):  # If they died during enemy turn
		player.input_controller.reset_moves_remaining()
	
	is_turn_processing = false


static func calculate_time_between_player_move() -> float:
	return DELAY_AFTER_MOVING + DELAY_AFTER_ITEMS + DELAY_AFTER_TILES + \
		DELAY_AFTER_ENEMIES + DELAY_AFTER_ENEMY_SPAWN + DELAY_AFTER_FLAG_SPAWN
