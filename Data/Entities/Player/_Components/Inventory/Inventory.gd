class_name Inventory
extends Object


var entity: Entity = null
var data: InventoryData = null
var items: Dictionary = {}  # ItemData : Item Scene


func _init(p_entity: Entity, p_data: InventoryData):
	entity = p_entity
	data = p_data


func add_starting_items():
	for item_data in data.starting_items:
		add_item(item_data, false)


func add_or_upgrade_item(item_data: ItemData, animate: bool = true) -> void:
	if item_data in items:
		upgrade_item(item_data, animate)
	else:
		add_item(item_data, animate)


func add_item(item_data: ItemData, animate: bool = true) -> void:
	var item: Item = item_data.item_scene.instantiate()
	items[item_data] = item
	
	var inventory_display: InventoryDisplay = GlobalGameState.game.player_overlay.inventory_display
	inventory_display.add_item_to_display(item, animate)
	item.setup(entity, item_data)
	
	GlobalSignals.item_added_to_inventory.emit(item, item_data)


func upgrade_item(item_data: ItemData, animate: bool = true) -> void:
	assert(items.has(item_data), "Trying to upgrade an item that the player doesn't have.")
	
	var item: Item = items[item_data]
	item.upgrade_tier()
	
	if animate:
		var inventory_display: InventoryDisplay = GlobalGameState.game.player_overlay.inventory_display
		inventory_display.animate_item_upgrade(item)
	
	GlobalSignals.item_increased_tier.emit(item, item_data)
	
	if item.is_max_tier():
		GlobalSignals.item_reached_max_tier.emit(item, item_data)
