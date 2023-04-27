@icon("res://Assets/art/logic-tree/triggers/up.png")
class_name LT_OnItemTierIncrease
extends LogicTreeTrigger


@export var item_filter: Item

@export var output_item_array: LT_ItemArrayVariable
@export var output_item_user: LT_EntityArrayVariable
@export var output_item_user_tile: LT_TileArrayVariable
@export var output_item_new_tier: LT_IntVariable


func _ready() -> void:
	super._ready()
	
	GlobalLogicTreeSignals.item_tier_increased.connect(trigger)


func trigger(item: Item) -> void:
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
	
	if output_item_new_tier != null:
		output_item_new_tier.value = item.current_tier
	
	logic_tree_on_trigger.evaluate()
