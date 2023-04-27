@icon("res://Assets/art/logic-tree/triggers/damage.png")
class_name LT_OnItemDealtDamage
extends LogicTreeTrigger


@export var item_filter: Item

@export var output_item_array: LT_ItemArrayVariable
@export var output_item_user: LT_EntityArrayVariable
@export var output_item_user_tile: LT_TileArrayVariable
@export var output_item_tier: LT_TileArrayVariable
@export var output_receiver_entity: LT_EntityArrayVariable
@export var output_receiver_tile: LT_TileArrayVariable
@export var output_damage: LT_IntVariable
@export var output_was_killing_blow: LT_BoolVariable


func _ready() -> void:
	super._ready()
	
	GlobalLogicTreeSignals.item_dealt_damage.connect(trigger)


func trigger(item: Item, receiver: Unit, amount: int, was_killing_blow: bool) -> void:
	assert(item != null, "Passed item is null for '" + name + "'")
	
	if item_filter != null and item != item_filter:
		return
	
	if output_item_array != null:
		output_item_array.value = [item]
	
	if output_item_user != null:
		if item.user != null:
			output_item_user.value = [item.user]
		else:
			output_item_user.value.clear()
	
	if output_item_user_tile != null:
		if item.user != null and item.user.current_tile != null:
			output_item_user_tile.value = [item.user.current_tile]
		else:
			output_item_user_tile.value.clear()
	
	if output_item_tier != null:
		output_item_tier.value = item.current_tier
	
	if output_receiver_entity != null:
		if receiver != null:
			output_receiver_entity.value = [receiver]
		else:
			output_receiver_entity.value.clear()
	
	if output_receiver_tile != null:
		if receiver != null and receiver.current_tile != null:
			output_receiver_tile.value = [receiver.current_tile]
		else:
			output_receiver_tile.value.clear()
	
	if output_damage != null:
		output_damage.value = amount
	
	if output_was_killing_blow != null:
		output_was_killing_blow.value = was_killing_blow
		
	logic_tree_on_trigger.evaluate()
