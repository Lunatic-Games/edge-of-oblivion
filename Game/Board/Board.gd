class_name Board
extends TileMap


signal tile_generation_completed

var tiles_at_coord: Dictionary = {}
var all_tiles: Array[Tile] = []
var unoccupied_tiles: Array[Tile] = []


func _ready() -> void:
	await get_tree().process_frame  # Need to wait for tile scenes to be instanced
	
	for child in get_children():
		var tile: Tile = child as Tile
		if tile == null:
			continue
		
		var map_coord: Vector2i = local_to_map(tile.position)
		tile.coord = map_coord
		all_tiles.append(tile)
		if tile.occupant == null:
			unoccupied_tiles.append(tile)
		tile.occupied_by_new_entity.connect(_on_tile_occupied_by_new_entity.bind(tile))
		tile.no_longer_occupied.connect(_on_tile_no_longer_occupied.bind(tile))

		tiles_at_coord[map_coord] = tile
	
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


func get_tile_at_position(pos: Vector2) -> Tile:
	var coord = local_to_map(to_local(pos))
	return tiles_at_coord.get(coord, null)


func _on_tile_occupied_by_new_entity(_occupant: Entity, tile: Tile) -> void:
	unoccupied_tiles.erase(tile)


func _on_tile_no_longer_occupied(tile: Tile) -> void:
	unoccupied_tiles.append(tile)
