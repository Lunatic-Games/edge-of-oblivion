@icon("res://Assets/art/logic-tree/effects/spawn.png")
class_name LT_SpawnIndicatorOnTiles
extends LogicTreeEffect


@export var tiles: LT_TileArrayVariable
@export var indicator_to_spawn: PackedScene = null
@export var mirror_x_if_left_of_first_tile: LT_TileArrayVariable


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")
	assert(indicator_to_spawn != null, "Indicator to spawn not set for '" + name + "'")
	assert(owner is Enemy, "Incorrect type of tree (non-enemy) for '" + name + "'")


func perform_behavior() -> void:
	for tile in tiles.value:
		var indicator: Indicator = indicator_to_spawn.instantiate()
		assert(indicator != null, "Failed to instaniate packed scene as an indicator for '" + name + "'")
		
		indicator.setup(owner)
		GlobalGameState.board.add_child(indicator)
		
		indicator.global_position = tile.global_position
		if mirror_x_if_left_of_first_tile != null:
			var reference_tiles: Array[Tile] = mirror_x_if_left_of_first_tile.value
			if not reference_tiles.is_empty():
				var first_tile: Tile = reference_tiles.front()
				if indicator.global_position < first_tile.global_position:
					indicator.scale.x *= -1
