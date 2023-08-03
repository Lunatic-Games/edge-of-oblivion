class_name SpawnFlag
extends Entity


func did_fail_to_relocate():
	return occupancy.current_tile == null


func destroy_self() -> void:
	occupancy.current_tile.occupant = null
	animator.play("quick_despawn")
	await animator.animation_finished
	queue_free()
