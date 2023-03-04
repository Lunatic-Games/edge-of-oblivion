extends Node

var debug_mode = true

var enemy_scene = preload("res://Data/Units/Enemies/Boss/ForgottenKing.tscn")

func _process(delta):
	if !debug_mode:
		return
	
	if Input.is_action_just_pressed("spawn_enemy_debug"):
		GameManager.spawn_enemy_at_tile(enemy_scene, GameManager.getRandomUnoccupiedTile())
	pass