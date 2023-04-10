extends CanvasLayer

const FULL_CARD_LIST: Array = [
	"res://Items/ShortSword/ShortSword.tres",
	"res://Items/LightningBow/LightningBow.tres",
	"res://Items/Hammer/Hammer.tres",
	"res://Items/TokenOfLove/TokenOfLove.tres",
	"res://Items/DragonCloak/DragonCloak.tres",
	"res://Items/HolyFire/HolyFire.tres",
	"res://Items/StrayArquebus/StrayArquebus.tres",
	"res://Items/Broom/Broom.tres",
	"res://Items/DraculasKnives/DraculasKnives.tres"
]

var CARD_SCENE = preload("res://UI/Card/Card.tscn")

var selectedCards = []
var available_cards = []


func _ready() -> void:
	for path in FULL_CARD_LIST:
		available_cards.append(path)


func reset():
	selectedCards = []
	available_cards = []
	for path in FULL_CARD_LIST:
		available_cards.append(path)
	disableDisplay()


func connectToPlayerTier(player):
	player.connect("item_reached_max_tier",Callable(self,"remove_item_from_availability"))


func display():
	$CardRow.visible = true


func disableDisplay():
	$CardRow.visible = false
	for child in $CardRow.get_children():
		child.queue_free()


func spawn_upgrade_cards(cardsToSpawn):
	available_cards.shuffle()
	display()
	
	for x in cardsToSpawn:
		if available_cards.size() <= 0:
			continue
		
		spawnCard(available_cards[0])
	
	for entry in selectedCards:
		available_cards.append(entry)
	selectedCards = []


func spawnCard(path_of_resource):
	var resource = load(path_of_resource)
	var card = CARD_SCENE.instantiate()
	var currentTier
	
	if resource in ItemManager.managedItems:
		currentTier = ItemManager.managedItems[resource].currentTier + 1
	else:
		currentTier = 1
	
	card.connect("selectionMade",Callable(self,"disableDisplay"))
	$CardRow.add_child(card)
	card.setup(resource, currentTier, true)
	selectedCards.append(path_of_resource)
	available_cards.erase(path_of_resource)


func remove_item_from_availability(item_data):
	available_cards.erase(item_data.path)
