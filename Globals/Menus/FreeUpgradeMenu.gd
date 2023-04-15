extends CanvasLayer

const FULL_CARD_LIST: Array[String] = [
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

const CARD_SCENE: PackedScene = preload("res://UI/Card/Card.tscn")

var selected_cards: Array[String] = []
var available_cards: Array[String] = []

@onready var card_row: BoxContainer = $CardRow


func _ready() -> void:
	for path in FULL_CARD_LIST:
		available_cards.append(path)


func reset() -> void:
	selected_cards = []
	available_cards = []
	for path in FULL_CARD_LIST:
		available_cards.append(path)
	disable_display()


func connectToPlayerTier(player: Player) -> void:
	player.connect("item_reached_max_tier",Callable(self,"remove_item_from_availability"))


func display() -> void:
	card_row.show()


func disable_display() -> void:
	card_row.hide()
	for child in card_row.get_children():
		child.queue_free()


func spawn_upgrade_cards(number_of_cards_to_spawn: int) -> void:
	available_cards.shuffle()
	display()
	
	for x in number_of_cards_to_spawn:
		if available_cards.size() <= 0:
			continue
		
		spawn_card(available_cards[0])
	
	for entry in selected_cards:
		available_cards.append(entry)
	selected_cards = []


func spawn_card(path_of_resource: String) -> void:
	var resource: ItemData = load(path_of_resource)
	var card: Card = CARD_SCENE.instantiate()
	var current_tier: int
	
	if resource in ItemManager.managed_items:
		current_tier = ItemManager.managed_items[resource].current_tier + 1
	else:
		current_tier = 1
	
	card_row.add_child(card)
	card.setup(resource, current_tier, true)
	card.selected.connect(disable_display)
	
	selected_cards.append(path_of_resource)
	available_cards.erase(path_of_resource)


func remove_item_from_availability(item_data: ItemData) -> void:
	available_cards.erase(item_data.path)
