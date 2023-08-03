@icon("res://Assets/art/logic-tree/triggers/damage.png")
class_name LT_OnEntityDamaged
extends LogicTreeEntityTrigger


enum SourceType {
	ANY,
	ANY_TILE,
	THIS_TILE,
	ANY_ITEM,
	THIS_ITEM,
	ANY_ENEMY,
	THIS_ENEMY
}

enum ReceiverType {
	ANY,
	PLAYER,
	ANY_ENEMY,
	THIS_ENEMY
}

@export var source_filter: SourceType = SourceType.ANY
@export var receiver_filter: ReceiverType = ReceiverType.ANY
@export var only_if_nonzero_amount: bool = true

@export var output_source_item_array: LT_ItemArrayVariable
@export var output_source_entity: LT_EntityArrayVariable
@export var output_source_tile: LT_TileArrayVariable

@export var output_receiver_entity: LT_EntityArrayVariable
@export var output_receiver_tile: LT_TileArrayVariable

@export var output_damage: LT_IntVariable
@export var output_was_killing_blow: LT_BoolVariable


func _ready() -> void:
	super._ready()
	
	GlobalLogicTreeSignals.entity_damaged.connect(trigger)


func trigger(source_item: Item, source_entity: Entity, source_tile: Tile,
	receiver_entity: Entity, damage_amount: int, was_killing_blow: bool) -> void:
	
	if only_if_nonzero_amount == true and damage_amount == 0:
		return
	
	if not does_match_source_filter(source_item, source_entity, source_tile):
		return
	
	if not does_match_receiver_filter(receiver_entity):
		return
	
	if output_source_item_array != null:
		if source_item != null:
			output_source_item_array.value = [source_item]
		else:
			output_source_item_array.value.clear()
	
	if output_source_entity != null:
		if source_entity != null:
			output_source_entity.value = [source_entity]
		elif source_item != null and source_item.user != null:
			output_source_entity.value = [source_item.user]
		else:
			output_source_entity.value.clear()
	
	if output_source_tile != null:
		if source_tile != null:
			output_source_tile.value = [source_tile]
		elif source_item != null and source_item.user != null and source_item.user.current_tile != null:
			output_source_tile.value = [source_item.user.current_tile]
		elif source_entity != null and source_entity.current_tile != null:
			output_source_tile.value = [source_entity.current_tile]
		else:
			output_source_tile.value.clear()
	
	if output_receiver_entity != null:
		if receiver_entity != null:
			output_receiver_entity.value = [receiver_entity]
		else:
			output_receiver_entity.value.clear()
	
	if output_receiver_tile != null:
		if receiver_entity != null and receiver_entity.current_tile != null:
			output_receiver_tile.value = [receiver_entity.current_tile]
		else:
			output_receiver_tile.value.clear()

	if output_damage != null:
		output_damage.value = damage_amount

	if output_was_killing_blow != null:
		output_was_killing_blow.value = was_killing_blow
		
	logic_tree_on_trigger.evaluate()


func does_match_source_filter(source_item: Item, source_entity: Entity, source_tile: Tile) -> bool:
	match source_filter:
		SourceType.ANY:
			return true
		SourceType.ANY_TILE:
			return source_tile != null
		SourceType.THIS_TILE:
			return source_tile != null and source_tile == owner
		SourceType.ANY_ITEM:
			return source_item != null
		SourceType.THIS_ITEM:
			return source_item != null and source_item == owner
		SourceType.ANY_ENEMY:
			var as_enemy: Enemy = source_entity as Enemy
			return as_enemy != null
		SourceType.THIS_ENEMY:
			var as_enemy: Enemy = source_entity as Enemy
			return as_enemy != null and as_enemy == owner
	
	return false


func does_match_receiver_filter(receiver_entity: Entity) -> bool:
	match receiver_filter:
		ReceiverType.ANY:
			return true
		ReceiverType.PLAYER:
			var as_player: Player = receiver_entity as Player
			return as_player != null
		ReceiverType.ANY_ENEMY:
			var as_enemy: Enemy = receiver_entity as Enemy
			return as_enemy != null
		ReceiverType.THIS_ENEMY:
			var as_enemy: Enemy = receiver_entity as Enemy
			return as_enemy != null and as_enemy == owner
	
	return false
