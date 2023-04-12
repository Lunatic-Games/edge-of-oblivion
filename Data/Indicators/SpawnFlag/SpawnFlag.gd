extends "res://Data/Occupant.gd"

var current_tile: Tile

@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	occupant_type = OccupantType.COLLECTABLE
	animator.play("spawn")


func collect() -> void:
	var new_tile: Tile = GameManager.get_random_unoccupied_tile()
	current_tile.occupant = null
	current_tile = new_tile
	position = current_tile.position
	GameManager.occupy_tile(current_tile, self)


func destroy_self() -> void:
	current_tile.occupant = null
	animator.play("remove")
	await animator.animation_finished
	queue_free()
