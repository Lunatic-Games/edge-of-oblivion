extends CanvasLayer

var cardScene = preload("res://Card.tscn")
var availableCards = [
	"res://Item/ShortSword/ShortSword.tres",
	"res://Item/LightningBow/LightningBow.tres",
	"res://Item/Hammer/Hammer.tres"
]
var selectedCards = []

func reset():
	selectedCards = []
	availableCards = [
	"res://Item/ShortSword/ShortSword.tres",
	"res://Item/LightningBow/LightningBow.tres",
	"res://Item/Hammer/Hammer.tres"]
	disableDisplay()

func connectToPlayerTier(player):
	player.connect("itemReachedMaxTier", self, "removeItemFromAvailability")

func display():
	$CardRow.visible = true

func disableDisplay():
	$CardRow.visible = false
	for child in $CardRow.get_children():
		child.queue_free()

func spawnUpgradeCards(cardsToSpawn):
	display()
	
	for x in cardsToSpawn:
		if availableCards.size() <= 0:
			continue
		
		spawnCard(availableCards[0])
	
	for entry in selectedCards:
		availableCards.append(entry)
	selectedCards = []

func spawnCard(pathOfResource):
	var resource = load(pathOfResource)
	var card = cardScene.instance()
	var currentTier
	
	if resource in ItemManager.managedItems:
		currentTier = ItemManager.managedItems[resource].currentTier + 1
	else:
		currentTier = 1
		
	card.setup(resource, currentTier)
	card.connect("selectionMade", self, "disableDisplay")
	$CardRow.add_child(card)
	selectedCards.append(pathOfResource)
	availableCards.remove(pathOfResource)
	

func removeItemFromAvailability(itemData):
	availableCards.remove(availableCards.find(itemData.path))
