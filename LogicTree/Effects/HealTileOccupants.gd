@icon("res://Assets/art/logic-tree/effects/heal.png")
class_name LT_HealTileOccupants
extends LogicTreeEffect


@export var tiles: LT_TileArrayVariable
@export var heal: int
@export var heal_override: LT_IntVariable
@export var output_total_healed: LT_IntVariable

@export var emit_heal_signal: bool = true


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")


func perform_behavior() -> void:
	if heal_override != null:
		heal = heal_override.value
	
	var total_healed: int = 0
	for tile in tiles.value:
		var unit: Unit = tile.occupant as Unit
		if unit == null:
			continue
		
		var amount_healed = unit.heal(heal)
		if amount_healed > 0:
			total_healed += amount_healed
			handle_heal_signal(amount_healed, unit)
	
	if output_total_healed != null:
		output_total_healed.value = total_healed


func handle_heal_signal(amount_healed: int, healed_entity: Unit):
	if (owner as Tile) != null:
		GlobalLogicTreeSignals.entity_healed.emit(null, null, owner, healed_entity, amount_healed)
	elif (owner as Unit) != null:
		GlobalLogicTreeSignals.entity_healed.emit(null, owner, null, healed_entity, amount_healed)
	elif (owner as Item) != null:
		GlobalLogicTreeSignals.entity_healed.emit(owner, null, null, healed_entity, amount_healed)
