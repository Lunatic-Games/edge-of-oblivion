extends LogicTree


enum PrimaryDirection {
	UP = 1,
	RIGHT = 2,
	DOWN = 4,
	LEFT = 8
}

enum Diagonals {
	UP_RIGHT = 1,
	RIGHT_DOWN = 2,
	DOWN_LEFT = 4,
	LEFT_UP = 8
}


@export var input_tile_array: LogicTreeTileArrayVariable
@export var output_tile_array: LogicTreeTileArrayVariable
@export_flags("🡱", "🡲", "🡳", "🡰") var primary_directions: int
#@export_flags("🡵", "🡶", "🡷", "🡴") var diagonals: int
@export_range(1, 10, 1, "or_greater") var primary_distance_start: int = 1
@export_range(1, 10, 1, "or_greater") var primary_distance_length: int = 1
@export var operation: LogicTreeSelection.Operation
@export var no_duplicates_in_result: bool = true


func _ready() -> void:
	assert(input_tile_array, "Tile array variable not set")


# TODO: Support diagonals. This should look up tiles directly rather than relying on tile connections
func perform_behavior() -> void:
	var scanned_tiles: Array[Tile] = []
	
	for tile in input_tile_array.value:
		if primary_directions & PrimaryDirection.UP:
			var scan_result: Array[Tile] = scan(tile, PrimaryDirection.UP)
			scanned_tiles.append_array(scan_result)
			
		if primary_directions & PrimaryDirection.RIGHT:
			var scan_result: Array[Tile] = scan(tile, PrimaryDirection.RIGHT)
			scanned_tiles.append_array(scan_result)
		
		if primary_directions & PrimaryDirection.DOWN:
			var scan_result: Array[Tile] = scan(tile, PrimaryDirection.DOWN)
			scanned_tiles.append_array(scan_result)
		
		if primary_directions & PrimaryDirection.LEFT:
			var scan_result: Array[Tile] = scan(tile, PrimaryDirection.LEFT)
			scanned_tiles.append_array(scan_result)
	
	output_tile_array.value = LogicTreeSelection.perform_operation_on_tiles(output_tile_array.value,
		scanned_tiles, operation, no_duplicates_in_result)


func scan(origin_tile: Tile, direction: PrimaryDirection) -> Array[Tile]:
	var scanned_tiles: Array[Tile] = []
	var current_tile: Tile = tile_from_direction(origin_tile, direction)
	
	for i in primary_distance_start + primary_distance_length - 1:
			if current_tile == null:
				break
			if i >= primary_distance_start - 1:
				scanned_tiles.append(current_tile)
			current_tile = tile_from_direction(current_tile, direction)
	
	return scanned_tiles


func tile_from_direction(tile: Tile, direction: PrimaryDirection) -> Tile:
	match direction:
		PrimaryDirection.UP:
			return tile.top_tile
		PrimaryDirection.RIGHT:
			return tile.right_tile
		PrimaryDirection.DOWN:
			return tile.bottom_tile
		PrimaryDirection.LEFT:
			return tile.left_tile
	
	return null
