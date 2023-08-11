@tool
extends Spawner


func spawn_entity():
	var board: Board = GlobalGameState.get_board()
	var tile: Tile = board.get_tile_at_position(global_position)

	if tile == null or tile.occupant:
		assert(false, "Invalid tile to spawn on")
		queue_free()
		return
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	var level_data: LevelData = GlobalGameState.get_game().level_data
	if level_data.next_level:
		spawn_handler.spawn_gateway(level_data.next_level, tile)
	
	queue_free()
