extends Node2D

var animator

func _ready():
	TurnManager.connect("playerTurnEnded", self, "destroySelf")
	animator = $AnimationPlayer
	animator.play("spawn")

func destroySelf():
	animator.play("remove")
	yield(animator, "animation_finished")
	queue_free()
