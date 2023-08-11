class_name Indicator
extends Node2D


var removing: bool = false

@onready var animator: AnimationPlayer = $AnimationPlayer


func setup(enemy_spawned_by: Enemy):
	enemy_spawned_by.update_triggered.connect(remove, CONNECT_ONE_SHOT)
	enemy_spawned_by.health.died.connect(_on_enemy_died, CONNECT_ONE_SHOT)


func remove() -> void:
	if removing == true:
		return
	
	removing = true
	animator.play("remove")
	await animator.animation_finished
	queue_free()


func _on_enemy_died(_source: int) -> void:
	remove()
