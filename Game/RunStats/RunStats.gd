class_name RunStats
extends Node


var n_enemies_killed: int = 0
var n_bosses_killed: int = 0
var xp_gained: int = 0


func _ready() -> void:
	GlobalSignals.enemy_killed.connect(_on_enemy_killed)


func _on_enemy_killed(enemy: Enemy):
	n_enemies_killed += 1
	if enemy.data.is_boss:
		n_bosses_killed += 1
	
	xp_gained += enemy.xp
