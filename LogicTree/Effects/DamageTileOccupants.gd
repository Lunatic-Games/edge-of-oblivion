@icon("res://Assets/art/logic-tree/effects/damage.png")
class_name LT_DamageTileOccupants
extends LogicTree


@export var tiles: LT_TileArrayVariable
@export var damage: int
@export var damage_override: LT_IntVariable
@export var output_total_damage: LT_IntVariable


func _ready() -> void:
	assert(tiles != null, "Tiles for '" + name + "' not set")


func perform_behavior() -> void:
	if damage_override != null:
		damage = damage_override.value
	
	var total_damage_dealt: int = 0
	for tile in tiles.value:
		var unit: Unit = tile.occupant as Unit
		if unit == null:
			continue
		
		total_damage_dealt += unit.take_damage(damage)
	
	if output_total_damage != null:
		output_total_damage.value = total_damage_dealt
