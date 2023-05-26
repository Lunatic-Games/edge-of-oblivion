@icon("res://Assets/art/logic-tree/operations/i.png")
class_name LT_GetThisItem
extends LogicTreeGetterOperation


@export var output_item: LT_ItemArrayVariable
@export var output_user_entity: LT_EntityArrayVariable
@export var output_user_tile: LT_TileArrayVariable


func perform_behavior() -> void:
	var this_item: Item = owner as Item
	assert(this_item != null,
			"Trying to get 'this item' for '" + name + "'but 'this item' is not an item")
	
	if output_item != null:
		output_item.value = [this_item]
	
	if output_user_entity != null:
		if this_item.user != null:
			output_user_entity.value = [this_item.user]
		else:
			output_user_entity.value.clear()
	
	if output_user_tile != null:
		if this_item.user != null and this_item.user.current_tile != null:
			output_user_tile.value = [this_item.user.current_tile]
		else:
			output_user_tile.value.clear()
