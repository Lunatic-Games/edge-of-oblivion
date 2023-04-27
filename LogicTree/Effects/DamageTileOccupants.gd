@icon("res://Assets/art/logic-tree/effects/damage.png")
class_name LT_DamageTileOccupants
extends LogicTreeEffect


@export var tiles: LT_TileArrayVariable
@export var damage: int
@export var damage_override: LT_IntVariable
@export var output_total_damage: LT_IntVariable
@export var emit_damage_signal: bool = true


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")


func perform_behavior() -> void:
	if damage_override != null:
		damage = damage_override.value
	
	var total_damage_dealt: int = 0
	var entities_killed: Array[Unit] = []
	var owner_as_item = owner as Item
	
	for tile in tiles.value:
		var unit: Unit = tile.occupant as Unit
		if unit == null:
			continue
		
		var damage_dealt = unit.take_damage(damage)
		if damage_dealt > 0:
			entities_killed.append(unit)
			total_damage_dealt += damage_dealt
			
			if emit_damage_signal == true and owner_as_item != null:
				var was_killing_blow: bool = not unit.is_alive()
				GlobalLogicTreeSignals.item_dealt_damage.emit(owner_as_item, unit, damage_dealt,
					was_killing_blow)
	
	if output_total_damage != null:
		output_total_damage.value = total_damage_dealt
