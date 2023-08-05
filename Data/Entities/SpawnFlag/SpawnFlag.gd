class_name SpawnFlag
extends Entity


func setup(p_data: EntityData) -> void:
	super.setup(p_data)
	occupancy.collected.connect(_on_collected)


func did_fail_to_relocate() -> bool:
	return occupancy.current_tile == null


func destroy_self() -> void:
	occupancy.current_tile.occupant = null
	animator.play("quick_despawn")
	await animator.animation_finished
	queue_free()


func _on_collected(_by: Entity) -> void:
	var new_tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	
	if new_tile == null:
		occupancy.current_tile = null  # Makes the spawn flag invalid for anything trying to use it
		queue_free()
		return
	
	animator.play("spawn")
	occupancy.move_to_tile(new_tile)
#	current_tile = new_tile
#	current_tile.occupant = self
#	global_position = current_tile.global_position
