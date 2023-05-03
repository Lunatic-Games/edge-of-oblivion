@icon("res://Assets/art/logic-tree/operations/distance.png")
class_name LT_SelectClosestTiles
extends LogicTreeOperation


const DISTANCE_COMPARISON_EPSILON: float = 0.000001

@export var tiles: LT_TileArrayVariable
@export var tiles_to_measure_to: LT_TileArrayVariable
@export var output_tiles: LT_TileArrayVariable


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")
	assert(tiles_to_measure_to != null, "Tiles to measure to not set for '" + name + "'")
	assert(output_tiles != null, "Output tiles not set for '" + name + "'")


func perform_behavior() -> void:
	var measure_position: Vector2 = Vector2.ZERO
	for tile in tiles_to_measure_to.value:
		measure_position += tile.global_position
	if tiles_to_measure_to.value.size() > 0:
		measure_position /= tiles_to_measure_to.value.size()
	
	var closest_distance_squared: float = INF
	var closest_tiles: Array[Tile] = []
	
	for tile in tiles.value:
		var distance_squared: float = tile.global_position.distance_squared_to(measure_position)
		
		if abs(distance_squared - closest_distance_squared) < DISTANCE_COMPARISON_EPSILON:
			closest_tiles.append(tile)
		elif distance_squared < closest_distance_squared:
			closest_tiles.clear()
			closest_tiles.append(tile)
	
	output_tiles.value = closest_tiles
