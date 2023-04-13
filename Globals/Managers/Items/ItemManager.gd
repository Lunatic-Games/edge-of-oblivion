extends Control

var managed_items: Dictionary = {
	
}


func _ready() -> void:
	TurnManager.connect("player_turn_ended",Callable(self,"handle_items_triggering"))


func reset() -> void:
	managed_items = {}


func handle_items_triggering() -> void:
	for item in managed_items:
		await managed_items[item].trigger_timer()
	
	TurnManager.item_phase_ended()


func add_item(item_data: ItemData) -> void:
	var item: Item = item_data.item_scene.instantiate()
	item.currentTier = 1
	GameManager.player.item_container.add_child(item)
	managed_items[item_data] = item
	item.setup(item_data)


func upgrade_item(item_data: ItemData) -> void:
	var is_max_tier = managed_items[item_data].upgrade_tier()
	
	if is_max_tier:
		FreeUpgradeMenu.remove_item_from_availability(item_data)
