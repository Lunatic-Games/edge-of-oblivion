@icon("res://Assets/art/logic-tree/effects/spawn.png")
class_name LT_SpawnNode2DOnTiles
extends LogicTreeEffect


@export var tiles: LT_TileArrayVariable
@export var node2d_to_spawn: PackedScene = null
@export var mirror_x_if_left_of_first_tile: LT_TileArrayVariable
@export var only_if_occupied_tile: bool = false


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")
	assert(node2d_to_spawn != null, "Node to spawn not set for '" + name + "'")


func perform_behavior() -> void:
	for tile in tiles.value:
		if only_if_occupied_tile and tile.occupant == null:
			continue
		
		var node: Node2D = node2d_to_spawn.instantiate()
		assert(node != null, "Failed to instaniate packed scene as a Node2D for '" + name + "'")
		GameManager.gameboard.add_child(node)
		
		node.global_position = tile.global_position
		if mirror_x_if_left_of_first_tile != null:
			var reference_tiles: Array[Tile] = mirror_x_if_left_of_first_tile.value
			if not reference_tiles.is_empty():
				var first_tile: Tile = reference_tiles.front()
				if node.global_position < first_tile.global_position:
					node.scale.x *= -1
