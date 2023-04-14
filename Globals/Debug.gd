extends Node

const FADED_SCENE: PackedScene = preload("res://Data/Units/Enemies/Faded/Faded.tscn")
const RANGER_SCENE: PackedScene = preload("res://Data/Units/Enemies/LostRanger/LostRanger.tscn")
const PIKE_SCENE: PackedScene = preload("res://Data/Units/Enemies/ForswornPike/ForswornPike.tscn")
const BOSS_SCENE: PackedScene = preload("res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()


func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("debug_level_up"):
		FreeUpgradeMenu.spawn_upgrade_cards(3)
	
	if Input.is_action_just_pressed("debug_heal_player"):
		if GameManager.player != null:
			GameManager.player.heal(GameManager.player.max_hp)
	
	if Input.is_action_just_pressed("debug_damage_player"):
		if GameManager.player != null:
			GameManager.player.take_damage(int(float(GameManager.player.max_hp) / 2.0))
	
	if Input.is_action_just_pressed("debug_kill_all_enemies"):
		# Iterate backwards since elements are deleted as they die
		for i in range(GameManager.all_enemies.size() - 1, -1, -1):
			GameManager.all_enemies[i].take_damage(GameManager.all_enemies[i].max_hp)
	
	if Input.is_action_just_pressed("debug_restart_game"):
		GameManager.stop_game()
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("debug_spawn_faded"):
		_spawn_enemy_scene(FADED_SCENE)
	
	if Input.is_action_just_pressed("debug_spawn_ranger"):
		_spawn_enemy_scene(RANGER_SCENE)
	
	if Input.is_action_just_pressed("debug_spawn_pike"):
		_spawn_enemy_scene(PIKE_SCENE)
	
	if Input.is_action_just_pressed("debug_spawn_boss"):
		_spawn_enemy_scene(BOSS_SCENE)


func _spawn_enemy_scene(scene: PackedScene):
	var tile: Tile = GameManager.get_random_unoccupied_tile()
	if tile:
		GameManager.spawn_enemy_at_tile(scene, tile)
