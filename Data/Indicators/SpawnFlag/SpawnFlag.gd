class_name SpawnFlag
extends Occupant


@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	occupant_type = OccupantType.COLLECTABLE
	animator.play("spawn")


func collect() -> void:
	current_tile.occupant = null
	
	var new_tile: Tile = GameManager.board.get_random_unoccupied_tile()
	if new_tile == null:
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
