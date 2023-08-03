class_name Inventory
extends Object


var entity: Entity = null
var data: InventoryData = null
var items: Dictionary = {}  # ItemData : Item Scene


func _init(p_entity: Entity, p_data: InventoryData):
	entity = p_entity
	data = p_data
	for item_data in data.starting_items:
		gain_item(item_data)


func gain_item(item_data: ItemData) -> void:
	if item_data in items:
		_handle_upgrading_item(item_data)
	else:
		_handle_new_item(item_data)


func _handle_new_item(item_data: ItemData) -> void:
	var item: Item = item_data.item_scene.instantiate()
	item.current_tier = 1
	item.user = entity
	items[item_data] = item
	GlobalSignals.item_added_to_inventory.emit(item, item_data)


func _handle_upgrading_item(item_data: ItemData) -> void:
	assert(items.has(item_data), "Trying to upgrade an item that the player doesn't have.")
	
	var item: Item = items[item_data]
	item.upgrade_tier()
	GlobalSignals.item_increased_tier.emit(item, item_data)
	
	if item.is_max_tier():
		GlobalSignals.item_reached_max_tier.emit(item, item_data)
