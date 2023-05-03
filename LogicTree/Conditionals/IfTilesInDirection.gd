@icon("res://Assets/art/logic-tree/conditionals/adjacent.png")
class_name LT_IfTilesInDirection
extends LogicTreeConditional


enum Direction {
	UP = 1,
	RIGHT = 2,
	DOWN = 4,
	LEFT = 8
}

enum Condition {
	#All,
	AVERAGE #,
	#None
}

enum Reference {
	AVERAGE #,
	#Each
}

@export var tiles: LT_TileArrayVariable
@export var reference_tiles: LT_TileArrayVariable
@export var direction: Direction
@export var reference: Reference
@export var condition: Condition


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")
	assert(reference_tiles != null, "Reference tiles not set for '" + name + "'")


func evaluate_condition() -> bool:
	if tiles.value.is_empty() or reference_tiles.value.is_empty():
		return false
	
	var average_tile_position: Vector2 = Vector2.ZERO
	for tile in tiles.value:
		average_tile_position += tile.global_position
	if tiles.value.size() > 0:
		average_tile_position /= tiles.value.size()
	
	var average_reference_position: Vector2 = Vector2.ZERO
	for tile in reference_tiles.value:
		average_reference_position += tile.global_position
	if reference_tiles.value.size() > 0:
		average_reference_position /= reference_tiles.value.size()
	
	if average_tile_position.y < average_reference_position.y and direction == Direction.UP:
		return true
	if average_tile_position.x > average_reference_position.x and direction == Direction.RIGHT:
		return true
	if average_tile_position.y > average_reference_position.y and direction == Direction.DOWN:
		return true
	if average_tile_position.x < average_reference_position.x and direction == Direction.LEFT:
		return true
	
	return false
