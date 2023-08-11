@tool
extends Spawner


const PLAYER_DATA: PlayerData = preload("res://Data/Entities/Player/PlayerData.tres")


func spawn_entity():
	var board: Board = GlobalGameState.get_board()
	var tile: Tile = board.get_tile_at_position(global_position)
	
	if tile == null:
		assert(false, "Player spawner is not placed over a valid tile")
		queue_free()
		return
	
	if tile.occupant != null:
		assert(false, "Player spawner is placed on an occupied tile")
		queue_free()
		return
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	var existing_player: Player = GlobalGameState.get_player()
	# If the player is set to persist then they will still be valid
	# If they aren't then they will be queued for being freed and be invalid
	if is_instance_valid(existing_player):
		spawn_handler.spawn_existing_player(existing_player, tile)
	else:
		spawn_handler.spawn_entity_on_tile(PLAYER_DATA, tile)
	
	queue_free()
