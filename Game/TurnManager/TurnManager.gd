class_name TurnManager
extends Node


var current_round: int = 0


func _ready() -> void:
	GlobalSignals.player_finished_moving.connect(_on_player_finished_moving)
	GlobalSignals.run_started.connect(_on_run_started)


func _on_run_started() -> void:
	current_round += 1
	var n_flags_spawned: int  = GlobalGameState.game.spawn_flags_for_next_round()


func _on_player_finished_moving(player: Player) -> void:
	for item in player.inventory.items.values():
		item.update()
	
	await get_tree().create_timer(0.1).timeout
	if GlobalGameState.game.upgrade_menu.visible:
		await GlobalGameState.game.upgrade_menu.visibility_changed
	
	await get_tree().create_timer(0.15).timeout
	
	for tile in GlobalGameState.board.all_tiles:
		tile.update()
	
	GlobalSignals.enemy_turn_started.emit()
	for enemy in GlobalGameState.game.spawn_handler.spawned_enemies:
		enemy.update()
	
	await get_tree().create_timer(0.2).timeout
	
	current_round += 1
	var n_enemies_spawned: int = GlobalGameState.game.spawn_enemies_for_round()
	await get_tree().create_timer(0.1).timeout
	
	var n_flags_spawned: int  = GlobalGameState.game.spawn_flags_for_next_round()
	await get_tree().create_timer(0.1).timeout
	GlobalSignals.new_round_started.emit()
	if is_instance_valid(player):  # If they died during enemy turn
		player.reset_moves_remaining()
