extends Control

class_name ItemManager

var managedItems = {
	
}

onready var itemContainer = $ItemContainer

func _ready():
	TurnManager.connect("playerTurnEnded", self, "handleItemsTriggering")

func handleItemsTriggering():
	for item in managedItems:
		yield(managedItems[item].triggerTimer(), "completed")
		if managedItems[item].is_ready_to_use():
			managedItems[item].start_blink()
	
	TurnManager.itemPhaseEnded()

func addItem(item_data):
	var item = item_data.itemScene.instance()
	item.currentTier = 1
	itemContainer.add_child(item)
	managedItems[item_data] = item
	item.setup(item_data)

func upgradeItem(itemData):
	var isMaxTier = managedItems[itemData].upgradeTier()
	
	if isMaxTier:
		FreeUpgradeMenu.removeItemFromAvailability(itemData)
