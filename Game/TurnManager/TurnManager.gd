class_name TurnManager
extends Node


var current_round: int = 0


func _ready() -> void:
	GlobalSignals.player_finished_moving.connect(_on_player_finished_moving)


func new_round() -> void:
	current_round += 1
	GlobalSignals.new_round_started.emit()


func _on_player_finished_moving(player: Player) -> void:
	for item in player.inventory.items.values():
		item.update()
	
	for tile in GlobalGameState.board.all_tiles:
		tile.update()
	
	for enemy in GlobalGameState.game.spawn_handler.spawned_enemies:
		enemy.update()
	
	new_round()
