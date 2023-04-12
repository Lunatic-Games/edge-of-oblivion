extends Control

var managedItems = {
	
}


func _ready():
	TurnManager.connect("player_turn_ended",Callable(self,"handle_items_triggering"))


func reset():
	managedItems = {}


func handle_items_triggering():
	for item in managedItems:
		await managedItems[item].trigger_timer()
	
	TurnManager.item_phase_ended()


func add_item(item_data: ItemData):
	var item = item_data.item_scene.instantiate()
	item.currentTier = 1
	GameManager.player.item_container.add_child(item)
	managedItems[item_data] = item
	item.setup(item_data)


func upgrade_item(item_data: ItemData):
	var isMaxTier = managedItems[item_data].upgrade_tier()
	
	if isMaxTier:
		FreeUpgradeMenu.remove_item_from_availability(item_data)
