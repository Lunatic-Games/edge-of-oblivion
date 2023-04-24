class_name Indicator
extends Node2D

@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animator.play("spawn")


func destroy_self() -> void:
	animator.play("remove")
	await animator.animation_finished
	queue_free()
