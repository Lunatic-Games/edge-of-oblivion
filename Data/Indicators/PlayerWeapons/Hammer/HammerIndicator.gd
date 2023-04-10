extends Node2D

@onready var animator = $AnimationPlayer


func _ready():
	animator.play("spawn")
	await animator.animation_finished
	queue_free()
