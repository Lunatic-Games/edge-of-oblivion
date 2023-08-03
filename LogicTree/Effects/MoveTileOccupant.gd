@icon("res://Assets/art/logic-tree/effects/move.png")
class_name LT_MoveTileOccupant
extends LogicTreeEffect


@export var tile: LT_TileArrayVariable
@export var destination_tile: LT_TileArrayVariable


func _ready() -> void:
	assert(tile != null, "Tile not set for '" + name + "'")
	assert(destination_tile != null, "Destination tile not set for '" + name + "'")


func perform_behavior() -> void:
	var tile_n: int = tile.value.size()
	assert(tile_n <= 1,
		"Start tile for '" + name + "' has " + str(tile_n) + "elements instead of 1")
	
	var destination_n: int = tile.value.size()
	assert(destination_n <= 1,
		"Destination tile for '" + name + "' has " + str(destination_n) + "elements instead of 1")
	
	if tile_n == 0 or destination_n == 0:
		return
	
	var tile_entity: Entity = tile.value[0].occupant as Entity
	assert(tile_entity != null,
		"Invalid move target for '" + name + "'")
	
	tile_entity.occupancy.move_to_tile(destination_tile.value[0])
