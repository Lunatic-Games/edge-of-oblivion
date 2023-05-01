@icon("res://Assets/art/logic-tree/triggers/start.png")
class_name LT_OnItemSetupCompleted
extends LogicTreeItemTrigger


enum ItemFilter {
	THIS_ITEM,
	ANY_ITEM
}

@export var item_filter: ItemFilter = ItemFilter.THIS_ITEM

@export var output_item_array: LT_ItemArrayVariable
@export var output_item_user: LT_EntityArrayVariable
@export var output_item_user_tile: LT_TileArrayVariable


func _ready() -> void:
	super._ready()
	
	if item_filter == ItemFilter.THIS_ITEM:
		var this_item: Item = owner as Item
		assert(this_item != null,
			"Item filter set to 'this item' for '" + name + "' but 'this item' is not an item")
		this_item.setup_completed.connect(trigger.bind(this_item))
	
	elif item_filter == ItemFilter.ANY_ITEM:
		GlobalLogicTreeSignals.item_setup_completed.connect(trigger)


func trigger(item: Item) -> void:
	assert(item != null, "Passed item is null for '" + name + "'")
	
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
	
	logic_tree_on_trigger.evaluate()
