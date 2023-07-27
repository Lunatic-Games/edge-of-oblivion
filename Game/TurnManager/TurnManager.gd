class_name TurnManager
extends Node


const DELAY_AFTER_MOVING: float = 0.05
const DELAY_AFTER_ITEMS: float = 0.15
const DELAY_AFTER_ENEMIES: float = 0.1
const DELAY_AFTER_ENEMY_SPAWN: float = 0.1
const DELAY_AFTER_FLAG_SPAWN: float = 0.1

var current_round: int = 0


func _ready() -> void:
	GlobalSignals.player_finished_moving.connect(_on_player_finished_moving)
	GlobalSignals.run_started.connect(_on_run_started)


func _on_run_started() -> void:
	current_round += 1
	GlobalGameState.game.spawn_flags_for_next_round()


func _on_player_finished_moving(player: Player) -> void:
	await get_tree().create_timer(DELAY_AFTER_MOVING).timeout
	for item in player.inventory.items.values():
		item.update()
	
	await get_tree().create_timer(DELAY_AFTER_ITEMS).timeout
	if GlobalGameState.game.upgrade_menu.visible:
		await GlobalGameState.game.upgrade_menu.visibility_changed
	
	for tile in GlobalGameState.board.all_tiles:
		tile.update()
	
	GlobalSignals.enemy_turn_started.emit()
	for enemy in GlobalGameState.game.spawn_handler.spawned_enemies:
		enemy.update()
	
	await get_tree().create_timer(DELAY_AFTER_ENEMIES).timeout
	
	current_round += 1
	GlobalGameState.game.spawn_enemies_for_round()
	await get_tree().create_timer(DELAY_AFTER_ENEMY_SPAWN).timeout
	
	GlobalGameState.game.spawn_flags_for_next_round()
	await get_tree().create_timer(DELAY_AFTER_FLAG_SPAWN).timeout
	GlobalSignals.new_round_started.emit()
	if is_instance_valid(player):  # If they died during enemy turn
		player.reset_moves_remaining()


func calculate_time_between_player_move() -> float:
	return DELAY_AFTER_MOVING + DELAY_AFTER_ITEMS + DELAY_AFTER_ENEMIES + \
		DELAY_AFTER_ENEMY_SPAWN + DELAY_AFTER_FLAG_SPAWN
