@icon("res://Assets/art/logic-tree/triggers/update.png")
class_name LT_OnEntityUpdate
extends LogicTreeEntityTrigger


enum EntityFilter {
	THIS_ENTITY,
	ANY_ENTITY
}

@export var entity_filter: EntityFilter = EntityFilter.THIS_ENTITY

@export var output_entity: LT_EntityArrayVariable
@export var output_entity_tile: LT_TileArrayVariable


func _ready() -> void:
	super._ready()
	
	if entity_filter == EntityFilter.THIS_ENTITY:
		var as_entity: Entity = owner as Entity
		assert(as_entity != null,
			"Entity filter set to 'this entity' for '" + name + "' but 'this entity' is not an entity")
		as_entity.update_triggered.connect(trigger.bind(as_entity))
	
	elif entity_filter == EntityFilter.ANY_ENTITY:
		GlobalLogicTreeSignals.entity_update_triggered.connect(trigger)


func trigger(entity: Entity) -> void:
	if output_entity != null:
		output_entity.value = [entity]
	
	if output_entity_tile != null:
		if entity.occupancy.primary_tile != null:
			output_entity_tile.value = [entity.occupancy.primary_tile]
		else:
			output_entity_tile.value.clear()
	
	logic_tree_on_trigger.evaluate()
