@icon("res://Assets/art/logic-tree/operations/radius.png")
class_name LT_SelectTilesInRadius
extends LogicTreeOperation


enum RadiusShape {
	DIAMOND,
	SQUARE
}

@export var input_tiles: LT_TileArrayVariable
@export var output_tiles: LT_TileArrayVariable
@export var shape: RadiusShape

@export_range(1, 10, 1, "or_greater") var radius: int = 0
@export var radius_override: LT_IntVariable

@export var operation: LogicTreeSelection.Operation

@export var include_origin_tile: bool = true
@export var no_duplicates_in_result: bool = true



func _ready() -> void:
	assert(input_tiles != null, "Input tiles not set for '" + name + "'")
	assert(output_tiles != null, "Output tiles not set for '" + name + "'")


func perform_behavior() -> void:
	if radius_override != null:
		radius = radius_override.value
	
	var scanned_tiles: Array[Tile] = []
	
	if shape == RadiusShape.DIAMOND:
		for tile in input_tiles.value:
			var scan_results: Array[Tile] = perform_diamond_flood_fill(tile)
			scanned_tiles.append_array(scan_results)
	
	elif shape == RadiusShape.SQUARE:
		for tile in input_tiles.value:
			var scan_results: Array[Tile] = perform_square_flood_fill(tile)
			scanned_tiles.append_array(scan_results)
	
	output_tiles.value = LogicTreeSelection.perform_operation_on_tiles(output_tiles.value,
		scanned_tiles, operation, no_duplicates_in_result)


func perform_diamond_flood_fill(start_tile: Tile) -> Array[Tile]:
	# [[Tile, DistanceFromStart], ...]
	var stack: Array[Array] = [[start_tile, 0]]
	var found_tiles: Array[Tile] = []
	
	while stack.is_empty() == false:
		var current: Array = stack.pop_front()
		var tile: Tile = current[0]
		var distance: int = current[1]
		if tile == null or distance > radius or tile in found_tiles:
			continue
		
		found_tiles.append(tile)
		stack.append([tile.top_tile, distance + 1])
		stack.append([tile.right_tile, distance + 1])
		stack.append([tile.bottom_tile, distance + 1])
		stack.append([tile.left_tile, distance + 1])
	
	if include_origin_tile == false:
		found_tiles.erase(start_tile)
	
	return found_tiles


func perform_square_flood_fill(start_tile: Tile) -> Array[Tile]:
	# [[Tile, HDistance, VDistance], ...]
	var stack: Array[Array] = [[start_tile, 0, 0]]
	var found_tiles: Array[Tile] = []
	
	while stack.is_empty() == false:
		var current: Array = stack.pop_front()
		var tile: Tile = current[0]
		var h_distance: int = current[1]
		var v_distance: int = current[2]
		
		if tile == null:
			continue
		
		var outside_radius: bool = abs(h_distance) > radius or abs(v_distance) > radius
		if outside_radius or tile in found_tiles:
			continue
		
		found_tiles.append(tile)
		stack.append([tile.top_tile, h_distance, v_distance - 1])
		stack.append([tile.right_tile, h_distance + 1, v_distance])
		stack.append([tile.bottom_tile, h_distance, v_distance + 1])
		stack.append([tile.left_tile, h_distance - 1, v_distance])
	
	if include_origin_tile == false:
		found_tiles.erase(start_tile)
	
	return found_tiles
