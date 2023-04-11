extends Node2D

@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animator.play("spawn")
	await animator.animation_finished
	queue_free()
