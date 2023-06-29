extends Node


const XP_FOR_ENEMY_KILL: int = 1
const EXTRA_XP_FOR_BOSS_KILL: int = 4

var n_enemies_killed: int = 0
var n_bosses_killed: int = 0


func _ready() -> void:
	GlobalSignals.enemy_killed.connect(_on_enemy_killed)


func calc_xp() -> int:
	var xp: int = 0
	xp += n_enemies_killed * XP_FOR_ENEMY_KILL
	xp += n_bosses_killed * (XP_FOR_ENEMY_KILL + EXTRA_XP_FOR_BOSS_KILL)
	return xp


func _on_enemy_killed(enemy: Enemy):
	n_enemies_killed += 1
	if enemy is Boss:
		n_bosses_killed += 1
