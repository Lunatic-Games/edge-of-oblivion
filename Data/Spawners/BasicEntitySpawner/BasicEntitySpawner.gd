@tool
extends Spawner


const DEFAULT_TEXTURE: Texture = preload("res://Assets/art/icons/targets/sbed/head-shot.svg")

@export var entity_data: EntityData = null:
	set = _set_entity_data


func spawn_entity():
	if entity_data == null:
		assert(false, "No entity data set for basic entity spawner")
		queue_free()
		return
	
	var board: Board = GlobalGameState.get_board()
	var tile: Tile = board.get_tile_at_position(global_position)
	
	if tile == null:
		assert(false, "Basic entity spawner is not placed over a valid tile")
		queue_free()
		return
	
	if tile.occupant != null:
		assert(false, "Basic entity spawner is placed on an occupied tile")
		queue_free()
		return
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	spawn_handler.spawn_entity_on_tile(entity_data, tile)
	queue_free()


func _set_entity_data(data: EntityData) -> void:
	entity_data = data
	if Engine.is_editor_hint() == false:
		return
	
	if entity_data == null or entity_data.sprite == null:
		texture = DEFAULT_TEXTURE
	else:
		texture = entity_data.sprite
