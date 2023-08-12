@icon("res://Assets/art/logic-tree/operations/adjacent.png")
class_name LT_SelectAdjacentTiles
extends LogicTreeOperation


enum Direction {
	UP = 1,
	RIGHT = 2,
	DOWN = 4,
	LEFT = 8
}

enum StopCondition {
	NO_CONDITION,
	ANY_ENTITY,
	PLAYER_ENTITY,
	ENEMY_ENTITY,
	NO_ENTITY
}

@export var input_tiles: LT_TileArrayVariable
@export var output_tiles: LT_TileArrayVariable
@export_flags("🡱", "🡲", "🡳", "🡰") var directions: int
@export_range(1, 10, 1, "or_greater") var distance_start: int = 1
@export_range(1, 10, 1, "or_greater") var distance_length: int = 1
@export var operation: LogicTreeSelection.Operation
@export var stop_condition: StopCondition = StopCondition.NO_CONDITION
@export var no_duplicates_in_result: bool = true


func _ready() -> void:
	assert(input_tiles != null, "Input tiles not set for '" + name + "'")
	assert(output_tiles != null, "Output tiles not set for '" + name + "'")


func perform_behavior() -> void:
	var scanned_tiles: Array[Tile] = []

	for tile in input_tiles.value:
		if directions & Direction.UP:
			var scan_result: Array[Tile] = scan(tile, Direction.UP)
			scanned_tiles.append_array(scan_result)

		if directions & Direction.RIGHT:
			var scan_result: Array[Tile] = scan(tile, Direction.RIGHT)
			scanned_tiles.append_array(scan_result)

		if directions & Direction.DOWN:
			var scan_result: Array[Tile] = scan(tile, Direction.DOWN)
			scanned_tiles.append_array(scan_result)

		if directions & Direction.LEFT:
			var scan_result: Array[Tile] = scan(tile, Direction.LEFT)
			scanned_tiles.append_array(scan_result)

	output_tiles.value = LogicTreeSelection.perform_operation_on_tiles(output_tiles.value,
		scanned_tiles, operation, no_duplicates_in_result)


func scan(origin_tile: Tile, direction: Direction) -> Array[Tile]:
	var scanned_tiles: Array[Tile] = []
	var current_tile: Tile = tile_from_direction(origin_tile, direction)

	for i in distance_start + distance_length - 1:
			if current_tile == null:
				break

			if i >= distance_start - 1:
				if tile_matches_stop_condition(current_tile):
					break
				scanned_tiles.append(current_tile)

			current_tile = tile_from_direction(current_tile, direction)

	return scanned_tiles


func tile_from_direction(tile: Tile, direction: Direction) -> Tile:
	match direction:
		Direction.UP:
			return tile.top_tile
		Direction.RIGHT:
			return tile.right_tile
		Direction.DOWN:
			return tile.bottom_tile
		Direction.LEFT:
			return tile.left_tile

	return null


func tile_matches_stop_condition(tile: Tile) -> bool:
	match stop_condition:
		StopCondition.NO_CONDITION:
			return false
		StopCondition.ANY_ENTITY:
			return tile.occupant != null
		StopCondition.PLAYER_ENTITY:
			return (tile.occupant as Player) != null
		StopCondition.ENEMY_ENTITY:
			return (tile.occupant as Enemy) != null
		StopCondition.NO_ENTITY:
			return tile.occupant == null
	return true
