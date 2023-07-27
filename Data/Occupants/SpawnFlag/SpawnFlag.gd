class_name SpawnFlag
extends Occupant


@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	occupant_type = OccupantType.COLLECTABLE


func collect() -> void:
	var new_tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	if current_tile.occupant == self:
		current_tile.occupant = null  # Don't set to null if something moved on to collect
	
	if new_tile == null:
		current_tile = null  # Makes the spawn flag invalid for anything trying to use it
		queue_free()
		return
	
	current_tile = new_tile
	current_tile.occupant = self
	global_position = current_tile.global_position


func destroy_self() -> void:
	current_tile.occupant = null
	animator.play("remove")
	await animator.animation_finished
	queue_free()
