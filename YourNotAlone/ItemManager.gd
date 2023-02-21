extends Control

var managedItems = {
	
}

#onready var itemContainer = $ItemContainer

func _ready():
	TurnManager.connect("playerTurnEnded", self, "handleItemsTriggering")

func reset():
	managedItems = {}

func handleItemsTriggering():
	for item in managedItems:
		yield(managedItems[item].triggerTimer(), "completed")
	
	TurnManager.itemPhaseEnded()

func addItem(item_data):
	var item = item_data.itemScene.instance()
	item.currentTier = 1
	GameManager.player.item_container.add_child(item)
	managedItems[item_data] = item
	item.setup(item_data)

func upgradeItem(itemData):
	var isMaxTier = managedItems[itemData].upgradeTier()
	
	if isMaxTier:
		FreeUpgradeMenu.removeItemFromAvailability(itemData)
