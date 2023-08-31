class_name SpawnFlag
extends Entity


signal freed_due_to_failed_move


func setup(p_data: EntityData, start_tile: Tile = null) -> void:
	super.setup(p_data, start_tile)
	occupancy.collected.connect(_on_collected)


func remove() -> void:
	occupancy.primary_tile.occupant = null
	occupancy.additional_tiles.clear()
	animator.play("quick_despawn")
	await animator.animation_finished
	queue_free()


func _on_collected(_by: Entity) -> void:
	var board: Board = GlobalGameState.get_board()
	var new_tile: Tile = board.get_random_unoccupied_tile()
	
	if new_tile == null:
		freed_due_to_failed_move.emit()
		queue_free()
		return
	
	animator.play("spawn")
	occupancy.move_to_tile(new_tile)
