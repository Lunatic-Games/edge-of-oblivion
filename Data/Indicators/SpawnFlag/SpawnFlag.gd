extends "res://Data/Occupant.gd"

var currentTile
onready var animator = $AnimationPlayer

func _ready():
	occupantType = occupantTypes.collectable
	animator.play("spawn")
	

func collect():
	var new_tile = GameManager.getRandomUnoccupiedTile()
	currentTile.occupied = null
	currentTile = new_tile
	position = currentTile.position
	GameManager.occupyTile(currentTile, self)

func destroySelf():
	currentTile.occupied = null
	animator.play("remove")
	yield(animator, "animation_finished")
	queue_free()
