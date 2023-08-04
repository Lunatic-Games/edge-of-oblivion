class_name SpawnHandler
extends Node


var PLAYER_DATA: PlayerData = load("res://Data/Entities/Player/PlayerData.tres")
const SPAWN_FLAG_DATA: EntityData = preload("res://Data/Entities/SpawnFlag/SpawnFlagData.tres")

var spawned_enemies: Array[Enemy] = []
var spawn_flags: Array[SpawnFlag] = []


func spawn_player() -> Player:
	var spawn_tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	assert(spawn_tile != null, "No free tile to spawn player on.")
	
	var player: Player = spawn_entity_on_tile(PLAYER_DATA, spawn_tile)
	GlobalSignals.player_spawned.emit(player)
	return player


func spawn_enemies(enemies: Array[EnemyData]) -> void:
	for enemy_data in enemies:
		var spawn_flag: SpawnFlag = spawn_flags.pop_front()
		if spawn_flag == null or spawn_flag.did_fail_to_relocate():
			# More enemies to spawn then there are spawn flags, map likely too small
			break
		spawn_flag.destroy_self()
		
		var _enemy: Enemy = spawn_enemy_on_tile(enemy_data, spawn_flag.occupancy.current_tile)
	
	assert(spawn_flags.is_empty(), "More spawn flags than enemies to spawn for this round.")


func spawn_enemy_on_tile(enemy_data: EnemyData, tile: Tile) -> Enemy:
	var enemy: Enemy = spawn_entity_on_tile(enemy_data, tile)
	spawned_enemies.append(enemy)
	
	enemy.health.died.connect(_on_enemy_died.bind(enemy))
	if enemy_data.is_boss():
		GlobalSignals.boss_spawned.emit(enemy)
	return enemy


func spawn_flags_for_next_turn(n_flags: int) -> void:
	for _i in n_flags:
		var spawn_tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
		if spawn_tile == null:
			# No more room to spawn
			break
		
		var spawn_flag: SpawnFlag = spawn_entity_on_tile(SPAWN_FLAG_DATA, spawn_tile)
		spawn_flags.append(spawn_flag)


func spawn_entity_on_tile(entity_data: EntityData, tile: Tile) -> Entity:
	var entity: Entity = entity_data.entity_scene.instantiate()
	assert(entity != null, "Failed to instantiate PackedScene as an Entity")
	
	GlobalGameState.board.add_child(entity)
	entity.setup(entity_data)
	
	tile.occupant = entity
	entity.occupancy.current_tile = tile
	entity.global_position = tile.global_position
	
	return entity


func _on_enemy_died(enemy: Enemy) -> void:
	spawned_enemies.erase(enemy)
