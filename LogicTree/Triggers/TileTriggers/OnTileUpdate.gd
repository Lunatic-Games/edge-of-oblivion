@icon("res://Assets/art/logic-tree/triggers/update.png")
class_name LT_OnTileUpdate
extends LogicTreeTileTrigger


enum TileFilter {
	THIS_TILE,
	ANY_TILE
}

@export var tile_filter: TileFilter = TileFilter.THIS_TILE

@export var output_tile: LT_TileArrayVariable
@export var output_occupant: LT_EntityArrayVariable


func _ready() -> void:
	super._ready()
	
	if tile_filter == TileFilter.THIS_TILE:
		var this_tile: Tile = owner as Tile
		assert(this_tile != null,
			"Tile filter set to 'this tile' for '" + name + "' but 'this tile' is not a tile")
		this_tile.update_triggered.connect(trigger.bind(this_tile))
	
	elif tile_filter == TileFilter.ANY_TILE:
		GlobalLogicTreeSignals.tile_update_triggered.connect(trigger)


func trigger(tile: Tile) -> void:
	assert(tile != null, "Passed tile is null for '" + name + "'")
	
	if output_tile != null:
		output_tile.value = [tile]

	if output_occupant != null:
		if tile.occupant != null:
			output_occupant.value = [tile.occupant]
		else:
			output_occupant.value.clear()
	
	logic_tree_on_trigger.evaluate()
