class_name EntityOccupancy
extends Object


var entity: Entity = null
var data: OccupancyData = null

var current_tile: Tile = null


func _init(p_entity: Entity, p_data: OccupancyData):
	entity = p_entity
	data = p_data


func move_to_tile(destination_tile: Tile) -> void:
	if data.can_move_to_tile(destination_tile) == false:
		return
	
	var destination_occupant: Entity = destination_tile.occupant
	if destination_occupant:
		var destination_occupancy: EntityOccupancy = destination_occupant.occupancy
		if destination_occupancy.blocking_behavior == OccupancyData.BlockingBehavior.OCCUPIED:
			var tile_to_displace_to: Tile = get_displace_tile(destination_tile)
			if tile_to_displace_to == null:
				return
			
			destination_occupancy.move_to_tile(tile_to_displace_to)
		else:
			return
			
	current_tile.occupant = null
	current_tile = destination_tile
	current_tile.occupant = entity


func get_displace_tile(base_tile: Tile) -> Tile:
	var possible_tiles: Array[Tile] = []
	if base_tile.top_tile && !base_tile.top_tile.occupant:
		possible_tiles.append(base_tile.top_tile)
	if base_tile.bottom_tile && !base_tile.bottom_tile.occupant:
		possible_tiles.append(base_tile.bottom_tile)
	if base_tile.left_tile && !base_tile.left_tile.occupant:
		possible_tiles.append(base_tile.left_tile)
	if base_tile.right_tile && !base_tile.right_tile.occupant:
		possible_tiles.append(base_tile.right_tile)
	
	if possible_tiles.size() > 0:
		return possible_tiles.pick_random()
	
	return null
