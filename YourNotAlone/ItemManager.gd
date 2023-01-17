extends Control

class_name ItemManager

var managedItems = {
	
}

onready var itemContainer = $ItemContainer

func _ready():
	TurnManager.connect("playerTurnEnded", self, "handleItemsTriggering")

func handleItemsTriggering():
	for item in managedItems:
		var has_become_ready = managedItems[item].triggerTimer()
		if has_become_ready:
			item.start_blink()
	
	TurnManager.itemPhaseEnded()

func addItem(itemData):
	var item = itemData.itemScene.instance()
	item.currentTier = 1
	itemContainer.add_child(item)
	managedItems[itemData] = item

func upgradeItem(itemData):
	var isMaxTier = managedItems[itemData].upgradeTier()
	
	if isMaxTier:
		FreeUpgradeMenu.removeItemFromAvailability(itemData)
