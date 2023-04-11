extends "res://Data/Occupant.gd"

var cardsToSpawn: int = 3
var current_tile: Tile

@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	occupant_type = OccupantTypes.COLLECTABLE
	animator.play("spawn")


func collect() -> void:
	FreeUpgradeMenu.spawn_upgrade_cards(cardsToSpawn)
	destroy_self()


func destroy_self() -> void:
	current_tile.occupant = null
	animator.play("remove")
	await animator.animation_finished
	queue_free()
