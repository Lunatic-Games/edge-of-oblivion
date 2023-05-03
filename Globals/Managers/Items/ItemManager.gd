extends Control

var managed_items: Dictionary = {
	
}


func _ready() -> void:
	TurnManager.connect("player_turn_ended",Callable(self,"handle_items_triggering"))


func reset() -> void:
	managed_items = {}


func handle_items_triggering() -> void:
	for item in managed_items:
		managed_items[item].update()
	
	TurnManager.item_phase_ended()


func add_item(item_data: ItemData) -> void:
	var item: Item = item_data.item_scene.instantiate()
	item.current_tier = 1
	GameManager.player.item_container.add_child(item)
	managed_items[item_data] = item
	item.setup(item_data)


func upgrade_item(item_data: ItemData) -> void:
	managed_items[item_data].upgrade_tier()
	
	if managed_items[item_data].current_tier == managed_items[item_data].max_tier:
		FreeUpgradeMenu.remove_item_from_availability(item_data)
