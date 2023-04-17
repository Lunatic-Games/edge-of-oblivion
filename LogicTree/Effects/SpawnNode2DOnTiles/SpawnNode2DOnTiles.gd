extends LogicTree


@export var tile_array: LogicTreeTileArrayVariable
@export var node_to_spawn: PackedScene = null
@export var mirror_x_if_left_of_first_tile: LogicTreeTileArrayVariable
@export var only_if_occupied_tile: bool = false


func _ready() -> void:
	assert(tile_array != null, "Tile array variable not set")
	assert(node_to_spawn != null, "Node to spawn not set")


func perform_behavior() -> void:
	for tile in tile_array.value:
		if only_if_occupied_tile and tile.occupant == null:
			continue
		
		var node: Node2D = node_to_spawn.instantiate()
		assert(node != null, "Failed to instaniate packed scene as a Node2D")
		GameManager.gameboard.add_child(node)
		
		node.global_position = tile.global_position
		if mirror_x_if_left_of_first_tile != null:
			var tiles: Array[Tile] = mirror_x_if_left_of_first_tile.value
			if not tiles.is_empty():
				var first_tile: Tile = tiles.front()
				if node.global_position < first_tile.global_position:
					node.scale.x *= -1
