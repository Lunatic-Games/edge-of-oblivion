extends "res://Data/Occupant.gd"

var cardsToSpawn = 3
var current_tile

@onready var animator = $AnimationPlayer

func _ready():
	occupantType = OccupantTypes.COLLECTABLE
	animator.play("spawn")

func collect():
	FreeUpgradeMenu.spawn_upgrade_cards(cardsToSpawn)
	destroy_self()

func destroy_self():
	current_tile.occupied = null
	animator.play("remove")
	await animator.animation_finished
	queue_free()
