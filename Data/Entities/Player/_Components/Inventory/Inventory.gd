class_name Inventory
extends RefCounted


var entity: Entity = null
var data: InventoryData = null
var items: Dictionary = {}  # ItemData : Item Scene
var gold: int = 0


func _init(p_entity: Entity, p_data: InventoryData):
	entity = p_entity
	data = p_data
	add_or_remove_gold(p_data.starting_gold)


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
	
	var game: Game = GlobalGameState.get_game()
	var inventory_display: InventoryDisplay = game.player_overlay.inventory_display
	inventory_display.add_item_to_display(item, animate)
	item.setup(entity, item_data, game.item_deck.get(item_data, 1))
	
	GlobalSignals.item_added_to_inventory.emit(item, item_data)


func upgrade_item(item_data: ItemData, animate: bool = true) -> void:
	assert(items.has(item_data), "Trying to upgrade an item that the player doesn't have.")
	
	var item: Item = items[item_data]
	item.upgrade_tier()
	
	if animate:
		var game: Game = GlobalGameState.get_game()
		var inventory_display: InventoryDisplay = game.player_overlay.inventory_display
		inventory_display.animate_item_upgrade(item)
	
	GlobalSignals.item_increased_tier.emit(item, item_data)
	
	if item.is_max_tier():
		GlobalSignals.item_reached_max_tier.emit(item, item_data)


func add_or_remove_gold(amount: int, animate: bool = true) -> void:
	if amount == 0:
		return
	
	gold += amount
	
	var game: Game = GlobalGameState.get_game()
	var gold_display: GoldDisplay = game.player_overlay.gold_display
	gold_display.set_display_amount(gold, animate)


func reset_items() -> void:
	items.clear()
	
	var game: Game = GlobalGameState.get_game()
	var inventory_display: InventoryDisplay = game.player_overlay.inventory_display
	inventory_display.reset_display()


func reset_gold() -> void:
	gold = 0
	var game: Game = GlobalGameState.get_game()
	var gold_display: GoldDisplay = game.player_overlay.gold_display
	gold_display.set_display_amount(0, false)
