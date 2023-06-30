extends Node

const FADED_SCENE: PackedScene = preload("res://Data/Occupants/Enemies/Faded/Faded.tscn")
const RANGER_SCENE: PackedScene = preload("res://Data/Occupants/Enemies/LostRanger/LostRanger.tscn")
const PIKE_SCENE: PackedScene = preload("res://Data/Occupants/Enemies/ForswornPike/ForswornPike.tscn")
const BOSS_SCENE: PackedScene = preload("res://Data/Occupants/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()


func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("debug_level_up"):
		if GlobalGameState.player != null:
			GlobalGameState.player.level_up()
	
	if Input.is_action_just_pressed("debug_heal_player"):
		if GlobalGameState.player != null:
			GlobalGameState.player.heal(GlobalGameState.player.max_hp)
	
	if Input.is_action_just_pressed("debug_damage_player"):
		if GlobalGameState.player != null:
			GlobalGameState.player.take_damage(int(float(GlobalGameState.player.max_hp) / 2.0))
	
	if Input.is_action_just_pressed("debug_kill_all_enemies"):
		# Iterate backwards since elements are deleted as they die
		var enemies: Array[Enemy] = GlobalGameState.game.spawn_handler.spawned_enemies
		for i in range(enemies.size() - 1, -1, -1):
			enemies[i].take_damage(enemies[i].max_hp)
	
	if Input.is_action_just_pressed("debug_restart_game"):
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
	var tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	if tile:
		GlobalGameState.game.spawn_handler.spawn_enemy_on_tile(scene, tile)
