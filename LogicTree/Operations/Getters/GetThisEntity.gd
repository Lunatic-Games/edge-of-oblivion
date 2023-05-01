@icon("res://Assets/art/logic-tree/operations/t.png")
class_name LT_GetThisEntity
extends LogicTreeGetterOperation


@export var output_entity: LT_EntityArrayVariable
@export var output_entity_tile: LT_TileArrayVariable


func perform_behavior() -> void:
	var this_entity: Occupant = owner as Occupant
	assert(this_entity != null,
			"Trying to get 'this entity' for '" + name + "'but 'this entity' is not an entity")
	
	if output_entity != null:
		output_entity.value = [this_entity]
	
	if output_entity_tile != null:
		if output_entity != null and output_entity.current_tile != null:
			output_entity_tile.value = [output_entity.current_tile]
		else:
			output_entity_tile.value.clear()
