@icon("res://Assets/art/logic-tree/triggers/start.png")
class_name LT_OnItemSetupCompleted
extends LogicTreeTrigger


@export var item: Item
@export var output_item_array: LT_ItemArrayVariable
@export var output_item_user: LT_EntityArrayVariable
@export var output_item_user_tile: LT_TileArrayVariable


func _ready() -> void:
	super._ready()
	assert(item != null, "Item not set for '" + name + "'")
	item.setup_completed.connect(trigger)


func trigger() -> void:
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
