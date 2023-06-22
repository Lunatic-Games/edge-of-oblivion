class_name SpawnManager
extends Node


const PLAYER_SCENE = preload("res://Data/Units/Player/Player.tscn")
const SPAWN_FLAG_SCENE = preload("res://Data/Indicators/SpawnFlag/SpawnFlag.tscn")

var spawned_enemies: Array[Enemy] = []
var spawn_flags: Array[SpawnFlag] = []


func spawn_player() -> Player:
	var spawn_tile: Tile = GameManager.board.get_random_unoccupied_tile()
	assert(spawn_tile != null, "No free tile to spawn player on.")
	return spawn_occupant_on_tile(PLAYER_SCENE, spawn_tile)


func spawn_enemies(enemies: Array[PackedScene]) -> void:
	for enemy_scene in enemies:
		var spawn_flag: SpawnFlag = spawn_flags.pop_front()
		if spawn_flag == null or spawn_flag.current_tile == null:  # Check for invalid due to failed move
			# More enemies to spawn then there are spawn flags, map likely too small
			break
		spawn_flag.destroy_self()
		
		var _enemy: Enemy = spawn_enemy_on_tile(enemy_scene, spawn_flag.current_tile)
	
	assert(spawn_flags.is_empty(), "More spawn flags than enemies to spawn for this round.")


func spawn_enemy_on_tile(enemy_scene: PackedScene, tile: Tile) -> Enemy:
	var enemy: Enemy = spawn_occupant_on_tile(enemy_scene, tile)
	spawned_enemies.append(enemy)
	enemy.died.connect(_on_enemy_died.bind(enemy))
	var as_boss: Boss = enemy as Boss
	if as_boss:
		GlobalSignals.boss_spawned.emit(as_boss)
	return enemy


func spawn_flags_for_next_turn(n_flags: int) -> void:
	for _i in n_flags:
		var spawn_tile: Tile = GameManager.board.get_random_unoccupied_tile()
		if spawn_tile == null:
			# No more room to spawn
			break
		
		var spawn_flag: SpawnFlag = spawn_occupant_on_tile(SPAWN_FLAG_SCENE, spawn_tile)
		spawn_flags.append(spawn_flag)


func spawn_occupant_on_tile(occupant_scene: PackedScene, tile: Tile) -> Occupant:
	var occupant: Occupant = occupant_scene.instantiate()
	assert(occupant != null, "Failed to instantiate PackedScene as an Occupant")
	
	GameManager.board.add_child(occupant)
	
	tile.occupant = occupant
	occupant.current_tile = tile
	occupant.global_position = tile.global_position
	
	return occupant


func _on_enemy_died(enemy: Enemy) -> void:
	spawned_enemies.erase(enemy)
