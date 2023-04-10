extends "res://Data/Occupant.gd"

var current_tile

@onready var animator = $AnimationPlayer


func _ready():
	occupantType = OccupantTypes.COLLECTABLE
	animator.play("spawn")


func collect():
	var new_tile = GameManager.get_random_unoccupied_tile()
	current_tile.occupied = null
	current_tile = new_tile
	position = current_tile.position
	GameManager.occupy_tile(current_tile, self)


func destroy_self():
	current_tile.occupied = null
	animator.play("remove")
	await animator.animation_finished
	queue_free()
