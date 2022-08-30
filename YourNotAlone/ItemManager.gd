extends Control

class_name ItemManager

var managedItems = {
	
}

onready var itemContainer = $ItemContainer

func addItem(itemData):
	var item = itemData.itemScene.instance()
	item.currentTier = 1
	itemContainer.add_child(item)
	managedItems[itemData] = item

func upgradeItem(itemData):
	var isMaxTier = managedItems[itemData].upgradeTier()
	
	if isMaxTier:
		FreeUpgradeMenu.removeItemFromAvailability(itemData)
