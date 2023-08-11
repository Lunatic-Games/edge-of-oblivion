@tool
class_name Spawner
extends Sprite2D


const DEFAULT_TEXTURE: Texture = preload("res://Assets/art/icons/targets/sbed/head-shot.svg")
const TILEMAP_SIZE: int = 70
const OFFSET: int = 35


@export var entity_data: EntityData = null:
	set = _set_entity_data


# To be called via call_group("spawner", "spawn_entity")
# Will be overriden by spawners that do something more specific
func spawn_entity():
	if entity_data == null:
		assert(false, "No entity set for spawner")
		queue_free()
		return
	
	var board: Board = GlobalGameState.get_board()
	var tile: Tile = board.get_tile_at_position(global_position)
	print(global_position)
	if tile == null or tile.occupant:
		assert(false, "Invalid tile to spawn on")
		queue_free()
		return
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	spawn_handler.spawn_entity_on_tile(entity_data, tile)
	queue_free()


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		set_notify_transform(true)


func _set_entity_data(data: EntityData) -> void:
	entity_data = data
	if Engine.is_editor_hint() == false:
		return
	
	if entity_data == null or entity_data.sprite == null:
		texture = DEFAULT_TEXTURE
	else:
		texture = entity_data.sprite


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		position.x = snappedi(position.x, TILEMAP_SIZE)
		position.y = snappedi(position.y, TILEMAP_SIZE)
