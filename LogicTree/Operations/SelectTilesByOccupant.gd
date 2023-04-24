@icon("res://Assets/art/logic-tree/operations/occupant.png")
class_name LT_SelectTilesByOccupants
extends LogicTreeOperation


enum OccupantType {
	AnyOccupant,
	PlayerEntity,
	EnemyEntity,
	NoOccupant
}

@export var input_tiles: LT_TileArrayVariable
@export var output_tiles: LT_TileArrayVariable
@export var occupant_type: OccupantType = OccupantType.AnyOccupant
@export var operation: LogicTreeSelection.Operation
@export var no_duplicates_in_result: bool = true


func _ready() -> void:
	assert(input_tiles != null, "Input tiles not set for '" + name + "'")
	assert(output_tiles != null, "Output tiles not set for '" + name + "'")


func perform_behavior() -> void:
	var selected_tiles: Array[Tile] = []
	
	for tile in input_tiles.value:
		var occupant = tile.occupant as Occupant
		
		if occupant == null:
			if occupant_type == OccupantType.NoOccupant:
				selected_tiles.append(tile)
			continue
		
		if occupant_type == OccupantType.AnyOccupant:
			selected_tiles.append(tile)
			continue
		
		if occupant_type == OccupantType.PlayerEntity:
			var as_player: Player = occupant as Player
			if as_player != null:
				selected_tiles.append(tile)
			continue
		
		if occupant_type == OccupantType.EnemyEntity:
			var as_enemy: Enemy = occupant as Enemy
			if as_enemy != null:
				selected_tiles.append(tile)
			continue
	
	output_tiles.value = LogicTreeSelection.perform_operation_on_tiles(output_tiles.value,
		selected_tiles, operation, no_duplicates_in_result)
