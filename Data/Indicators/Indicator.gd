class_name Indicator
extends Node2D

@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GlobalSignals.player_finished_moving.connect(_on_player_finished_moving)
	animator.play("spawn")


func _on_player_finished_moving(_player: Player) -> void:
	animator.play("remove")
	await animator.animation_finished
	queue_free()
