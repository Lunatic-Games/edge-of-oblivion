@icon("res://Assets/art/logic-tree/effects/spawn.png")
class_name LT_SpawnNode2DOnTiles
extends LogicTreeEffect


@export var tiles: LT_TileArrayVariable
@export var node2d_to_spawn: PackedScene = null
@export var mirror_x_if_left_of_first_tile: LT_TileArrayVariable

var active_spawned_nodes: Array[Node2D] = []


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")
	assert(node2d_to_spawn != null, "Node to spawn not set for '" + name + "'")


func perform_behavior() -> void:
	for tile in tiles.value:
		var node: Node2D = node2d_to_spawn.instantiate()
		assert(node != null, "Failed to instaniate packed scene as a Node2D for '" + name + "'")
		node.tree_entered.connect(_on_spawned_node_tree_entered.bind(node))
		node.tree_exited.connect(_on_spawned_node_tree_exited.bind(node))
		GlobalGameState.board.add_child(node)
		
		node.global_position = tile.global_position
		if mirror_x_if_left_of_first_tile != null:
			var reference_tiles: Array[Tile] = mirror_x_if_left_of_first_tile.value
			if not reference_tiles.is_empty():
				var first_tile: Tile = reference_tiles.front()
				if node.global_position < first_tile.global_position:
					node.scale.x *= -1


func _on_spawned_node_tree_entered(node: Node2D):
	assert(active_spawned_nodes.has(node) == false, "Node should not already be in list")
	active_spawned_nodes.append(node)


func _on_spawned_node_tree_exited(node: Node2D):
	active_spawned_nodes.erase(node)
