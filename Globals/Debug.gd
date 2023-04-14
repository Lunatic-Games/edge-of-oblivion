extends Node

const ENEMY_SCENE = preload("res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")


func _process(delta):
	if !OS.is_debug_build():
		return
	
	if Input.is_action_just_pressed("spawn_enemy_debug"):
		GameManager.spawn_enemy_at_tile(ENEMY_SCENE, GameManager.getRandomUnoccupiedTile())
	
	if Input.is_action_just_pressed("level_up"):
		FreeUpgradeMenu.spawnUpgradeCards(3)
	
	if Input.is_action_just_pressed("full_heal"):
		GameManager.player.heal(999)

