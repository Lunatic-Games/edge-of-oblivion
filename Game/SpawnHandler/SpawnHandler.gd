class_name SpawnHandler
extends Node


const PLAYER_DATA: PlayerData = preload("res://Data/Entities/Player/PlayerData.tres")
const SPAWN_FLAG_DATA: EntityData = preload("res://Data/Entities/SpawnFlag/SpawnFlag.tres")
const GATEWAY_DATA: EntityData = preload("res://Data/Entities/Gateway/Gateway.tres")

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
		if spawn_flag == null:
			# More enemies to spawn then there are spawn flags, map likely too small
			break
		
		spawn_flag.remove()
		spawn_entity_on_tile(enemy_data, spawn_flag.occupancy.current_tile)
	
	assert(spawn_flags.is_empty(), "More spawn flags than enemies to spawn for this round.")


func spawn_flags_for_next_turn(n_flags: int) -> void:
	for _i in n_flags:
		var spawn_tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
		if spawn_tile == null:
			# No more room to spawn
			break
		
		spawn_entity_on_tile(SPAWN_FLAG_DATA, spawn_tile)


func spawn_gateway(to: LevelData) -> void:
	var spawn_tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	var gateway: Gateway = spawn_entity_on_tile(GATEWAY_DATA, spawn_tile)
	gateway.set_destination(to)


func spawn_entity_on_tile(entity_data: EntityData, tile: Tile) -> Entity:
	var entity: Entity = entity_data.entity_scene.instantiate()
	assert(entity != null, "Failed to instantiate PackedScene as an Entity")
	
	GlobalGameState.board.add_child(entity)
	entity.setup(entity_data)
	
	tile.occupant = entity
	entity.occupancy.current_tile = tile
	entity.global_position = tile.global_position
	
	if entity is Enemy:
		_on_enemy_spawned(entity)
	elif entity is SpawnFlag:
		_on_spawn_flag_spawned(entity)
	
	return entity


func _on_enemy_spawned(enemy: Enemy) -> void:
	spawned_enemies.append(enemy)
	
	var enemy_data: EnemyData = enemy.data as EnemyData
	enemy.health.died.connect(_on_enemy_died.bind(enemy))
	if enemy_data.is_boss():
		GlobalSignals.boss_spawned.emit(enemy)


func _on_enemy_died(enemy: Enemy) -> void:
	spawned_enemies.erase(enemy)


func _on_spawn_flag_spawned(spawn_flag: SpawnFlag) -> void:
	spawn_flags.append(spawn_flag)
	spawn_flag.freed_due_to_failed_move.connect(_on_spawn_flag_freed_due_to_failed_move.bind(spawn_flag))


func _on_spawn_flag_freed_due_to_failed_move(spawn_flag: SpawnFlag) -> void:
	spawn_flags.erase(spawn_flag)
