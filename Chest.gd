extends "res://Occupant.gd"

var cardsToSpawn = 3
var currentTile

onready var animator = $AnimationPlayer

func _ready():
	occupantType = occupantTypes.collectable
	animator.play("spawn")

func collect():
	FreeUpgradeMenu.spawnUpgradeCards(cardsToSpawn)
	destroySelf()

func destroySelf():
	currentTile.occupied = null
	animator.play("remove")
	yield(animator, "animation_finished")
	queue_free()
