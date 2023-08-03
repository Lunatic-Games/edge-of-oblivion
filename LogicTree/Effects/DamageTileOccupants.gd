@icon("res://Assets/art/logic-tree/effects/damage.png")
class_name LT_DamageTileOccupants
extends LogicTreeEffect


@export var tiles: LT_TileArrayVariable
@export_range(0, 100, 1, "or_greater") var damage: int = 1
@export var damage_override: LT_IntVariable
@export var output_total_damage: LT_IntVariable

@export var emit_damage_signal: bool = true


func _ready() -> void:
	assert(tiles != null, "Tiles not set for '" + name + "'")


func perform_behavior() -> void:
	if damage_override != null:
		damage = damage_override.value
	
	var total_damage_dealt: int = 0
	var entities_killed: Array[Entity] = []
	
	for tile in tiles.value:
		var entity: Entity = tile.occupant as Entity
		if entity == null:
			continue
		
		var amount_damaged = entity.health.take_damage(damage)
		if amount_damaged > 0:
			entities_killed.append(entity)
			total_damage_dealt += amount_damaged
			
		if emit_damage_signal == true:
			handle_damage_signal(amount_damaged, entity)
	
	if output_total_damage != null:
		output_total_damage.value = total_damage_dealt


func handle_damage_signal(amount_damaged: int, damaged_entity: Entity):
	var was_killing_blow: bool = not damaged_entity.health.is_alive()
	if (owner as Tile) != null:
		GlobalLogicTreeSignals.entity_damaged.emit(null, null, owner, damaged_entity,
			amount_damaged, was_killing_blow)
	elif (owner as Entity) != null:
		GlobalLogicTreeSignals.entity_damaged.emit(null, owner, null, damaged_entity, 
		amount_damaged, was_killing_blow)
	elif (owner as Item) != null:
		GlobalLogicTreeSignals.entity_damaged.emit(owner, null, null, damaged_entity,
			amount_damaged, was_killing_blow)
