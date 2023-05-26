@icon("res://Assets/art/logic-tree/effects/clean.png")
class_name LT_FreeSpawnedNode2Ds
extends LogicTreeEffect


@export var spawner: LT_SpawnNode2DOnTiles


func _ready() -> void:
	assert(spawner != null, "Spawner not set for '" + name + "'")


func perform_behavior() -> void:
	for node in spawner.active_spawned_nodes:
		node.queue_free()
