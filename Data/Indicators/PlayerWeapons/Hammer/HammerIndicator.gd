extends Node2D

onready var animator = $AnimationPlayer

func _ready():
	animator.play("spawn")
	yield(animator, "animation_finished")
	queue_free()
