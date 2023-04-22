@icon("res://Assets/art/logic-tree/effects/heal.png")
class_name LT_HealTileOccupants
extends LogicTree


@export var tiles: LT_TileArrayVariable
@export var heal: int
@export var heal_override: LT_IntVariable
@export var output_total_healed: LT_IntVariable


func _ready() -> void:
	assert(tiles != null, "Tiles for '" + name + "' not set")


func perform_behavior() -> void:
	if heal_override != null:
		heal = heal_override.value
	
	var total_healed: int = 0
	for tile in tiles.value:
		var unit: Unit = tile.occupant as Unit
		if unit == null:
			continue
		
		total_healed += unit.heal(heal)
	
	if output_total_healed != null:
		output_total_healed.value = total_healed

