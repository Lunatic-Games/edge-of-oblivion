class_name DialogueTrigger
extends Entity


signal triggered


func setup(p_data: EntityData, start_tile: Tile = null) -> void:
	super.setup(p_data, start_tile)
	occupancy.collected.connect(_on_collected)


func _on_collected(_by: Entity) -> void:
	triggered.emit()
	
	if occupancy.primary_tile.occupant == self:
		occupancy.primary_tile.occupant = null
		occupancy.additional_tiles.clear()
	animator.play("quick_despawn")
	await animator.animation_finished
	queue_free()
