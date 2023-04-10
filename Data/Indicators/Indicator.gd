extends Node2D

@onready var animator = $AnimationPlayer


func _ready():
	TurnManager.player_turn_ended.connect(destroy_self)
	animator.play("spawn")


func destroy_self():
	animator.play("remove")
	await animator.animation_finished
	queue_free()
