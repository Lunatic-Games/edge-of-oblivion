@icon("res://Assets/art/logic-tree/triggers/update.png")
class_name LT_OnTileUpdate
extends LogicTreeTrigger


@export var tile: Tile
@export var output_tile: LT_TileArrayVariable
@export var output_occupant: LT_EntityArrayVariable


func _ready() -> void:
	super._ready()
	assert(tile != null, "Tile not set for '" + name + "'")
	tile.update_triggered.connect(trigger)


func trigger() -> void:
	if output_tile != null:
		output_tile.value = [tile]
	
	if output_occupant != null:
		if tile.occupant != null:
			output_occupant.value = [tile.occupant]
		else:
			output_occupant.value.clear()
	
	logic_tree_on_trigger.evaluate()
