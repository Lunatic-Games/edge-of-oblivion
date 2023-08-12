@icon("res://Assets/art/logic-tree/operations/occupant.png")
class_name LT_SelectTilesByOccupants
extends LogicTreeOperation


enum OccupantType {
	ANY_OCCUPANT,
	PLAYER_ENTITY,
	ENEMY_ENTITY,
	NO_OCCUPANT
}

@export var input_tiles: LT_TileArrayVariable
@export var output_tiles: LT_TileArrayVariable
@export var occupant_type: OccupantType = OccupantType.ANY_OCCUPANT
@export var operation: LogicTreeSelection.Operation
@export var no_duplicates_in_result: bool = true


func _ready() -> void:
	assert(input_tiles != null, "Input tiles not set for '" + name + "'")
	assert(output_tiles != null, "Output tiles not set for '" + name + "'")


func perform_behavior() -> void:
	var selected_tiles: Array[Tile] = []
	
	for tile in input_tiles.value:
		var entity = tile.occupant as Entity
		
		if entity == null:
			if occupant_type == OccupantType.NO_OCCUPANT:
				selected_tiles.append(tile)
			continue
		
		if occupant_type == OccupantType.ANY_OCCUPANT:
			selected_tiles.append(tile)
			continue
		
		if occupant_type == OccupantType.PLAYER_ENTITY:
			var as_player: Player = entity as Player
			if as_player != null:
				selected_tiles.append(tile)
			continue
		
		if occupant_type == OccupantType.ENEMY_ENTITY:
			var as_enemy: Enemy = entity as Enemy
			if as_enemy != null:
				selected_tiles.append(tile)
			continue
	
	output_tiles.value = LogicTreeSelection.perform_operation_on_tiles(output_tiles.value,
		selected_tiles, operation, no_duplicates_in_result)
