class_name Indicator
extends Node2D

@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GlobalSignals.enemy_turn_started.connect(_on_enemy_turn_started)


func _on_enemy_turn_started() -> void:
	animator.play("remove")
	await animator.animation_finished
	queue_free()
