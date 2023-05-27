class_name Board
extends TileMap


signal tile_generation_completed

var tiles_at_coord: Dictionary = {}
var all_tiles: Array[Tile] = []
var unoccupied_tiles: Array[Tile] = []


func _ready() -> void:
	await get_tree().process_frame
	
	for child in get_children():
		var as_tile: Tile = child as Tile
		if as_tile == null:
			continue
		
		var map_coord: Vector2i = local_to_map(as_tile.position)
		as_tile.coord = map_coord
		all_tiles.append(as_tile)
		if as_tile.occupant == null:
			unoccupied_tiles.append(as_tile)
		as_tile.occupied_by_new_occupant.connect(_on_tile_occupied_by_new_occupant.bind(as_tile))
		as_tile.no_longer_occupied.connect(_on_tile_no_longer_occupied.bind(as_tile))

		tiles_at_coord[map_coord] = as_tile
	
	for tile in all_tiles:
		tile.top_tile = tiles_at_coord.get(tile.coord + Vector2i.UP, null)
		tile.right_tile = tiles_at_coord.get(tile.coord + Vector2i.RIGHT, null)
		tile.bottom_tile = tiles_at_coord.get(tile.coord + Vector2i.DOWN, null)
		tile.left_tile = tiles_at_coord.get(tile.coord + Vector2i.LEFT, null)
		
	tile_generation_completed.emit()


func get_random_tile() -> Tile:
	if unoccupied_tiles.is_empty():
		return null
	
	return all_tiles.pick_random()


func get_random_unoccupied_tile() -> Tile:
	if unoccupied_tiles.is_empty():
		return null
	
	return unoccupied_tiles.pick_random()


func _on_tile_occupied_by_new_occupant(_occupant: Occupant, tile: Tile) -> void:
	unoccupied_tiles.erase(tile)


func _on_tile_no_longer_occupied(tile: Tile) -> void:
	unoccupied_tiles.append(tile)
