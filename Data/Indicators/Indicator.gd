extends Node2D

var animator

func _ready():
	TurnManager.connect("player_turn_ended",Callable(self,"destroy_self"))
	animator = $AnimationPlayer
	animator.play("spawn")

func destroy_self():
	animator.play("remove")
	await animator.animation_finished
	queue_free()
