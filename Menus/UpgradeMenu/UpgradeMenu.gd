extends CanvasLayer


signal picked_item  # Card picked but still animating
signal fully_finished_picking_item  # Cards freed

const CARD_SCENE: PackedScene = preload("res://UI/Card/Card.tscn")
const DISPLAY_FLOAT_UP_DISTANCE: float = 200.0
const DISPLAY_FLOAT_UP_TIME_SECONDS: float = 0.5
const DISPLAY_DELAY_BETWEEN_CARDS_SECONDS: float = 0.2

const NOT_CHOSEN_DROP_DISTANCE: float = 200.0
const NOT_CHOSEN_DROP_TIME_SECONDS: float = 0.5

const CHOSEN_RISE_DISTANCE: float = 50.0
const CHOSEN_RISE_TIME_SECONDS: float = 1.0

var available_items: Array[ItemData] = []  # Will become unavailable after reaching max tier
var displayed_items: Array[ItemData] = []
var is_currently_picking_item: bool = false

@onready var card_row: BoxContainer = $CardRow


func _ready() -> void:
	GlobalSignals.player_levelled_up.connect(_on_player_levelled_up)
	GlobalSignals.item_reached_max_tier.connect(_on_item_reached_max_tier)
	
	for item_data in GlobalAccount.unlocked_items:
		available_items.append(item_data)
	
	show()


func spawn_upgrade_cards(number_of_cards_to_spawn: int) -> void:
	# This is basically implementing a queue for upgrades displaying
	while is_currently_picking_item:
		await picked_item
	
	if available_items.is_empty() or GlobalGameState.game_ended:
		return
		
	# If there is a queued upgrade we want to wait for animations to finish,
	# but we still want to lock player movement.
	is_currently_picking_item = true
	
	if card_row.get_children():
		await fully_finished_picking_item
	
	assert(available_items.size() > 0, "No available items to display :(")
	var items_to_select_from: Array[ItemData] = []
	items_to_select_from.append_array(available_items)
	items_to_select_from.shuffle()
	
	for x in number_of_cards_to_spawn:
		if items_to_select_from.size() == 0:
			break
		
		var selected_item: ItemData = items_to_select_from[0]
		var float_up_delay = x * DISPLAY_DELAY_BETWEEN_CARDS_SECONDS
		add_card_to_display(selected_item, float_up_delay)
		items_to_select_from.erase(selected_item)


func add_card_to_display(item_data: ItemData, float_up_delay: float = 0.0) -> void:
	var card: Card = CARD_SCENE.instantiate()
	card_row.add_child(card)
	
	var item_tier: int = 1
	if GlobalGameState.player and item_data in GlobalGameState.player.inventory.items:
		item_tier = GlobalGameState.player.inventory.items[item_data].current_tier + 1
	
	card.setup(item_data, item_tier, true)
	
	card.selected.connect(_on_card_selected.bind(card))
	displayed_items.append(item_data)
	
	_float_card_up(card, float_up_delay)


func force_close_display() -> void:
	for child in card_row.get_children():
		child.queue_free()


func _on_player_levelled_up(_player: Player) -> void:
	spawn_upgrade_cards(3)


func _on_player_died(_player: Player) -> void:
	force_close_display()


func _on_boss_defeated(_boss: Boss) -> void:
	force_close_display()


func _on_item_reached_max_tier(_item: Item, item_data: ItemData) -> void:
	available_items.erase(item_data)


func _float_card_up(card: Card, delay: float = 0.0) -> void:
	card.modulate.a = 0.0
	
	await get_tree().process_frame  # Wait till container is all set-up
	if delay > 0.0:
		await get_tree().create_timer(delay).timeout
	
	card.position.y += DISPLAY_FLOAT_UP_DISTANCE  # Move down so it can float up to the same spot
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(card, "position:y", -DISPLAY_FLOAT_UP_DISTANCE, DISPLAY_FLOAT_UP_TIME_SECONDS) \
		.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(card, "modulate:a", 1.0, DISPLAY_FLOAT_UP_TIME_SECONDS) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func _on_card_selected(selected_card: Card) -> void:
	for child in card_row.get_children():
		var card: Card = child as Card
		assert(card != null, "Card row should only contain cards")
		card.selected.disconnect(_on_card_selected)
		
		if card == selected_card:
			if GlobalGameState.player:
				GlobalGameState.player.inventory.gain_item(card.held_item_data)
			_raise_chosen_card(card)
		else:
			_drop_unchosen_card(card)
	
	is_currently_picking_item = false
	picked_item.emit()


func _raise_chosen_card(card: Card) -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(card, "position:y", -CHOSEN_RISE_DISTANCE, CHOSEN_RISE_TIME_SECONDS) \
		.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(card, "modulate:a", 0.0, CHOSEN_RISE_TIME_SECONDS) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(_on_card_disappeared.bind(card))


func _drop_unchosen_card(card: Card) -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(card, "position:y", NOT_CHOSEN_DROP_DISTANCE, NOT_CHOSEN_DROP_TIME_SECONDS) \
		.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(card, "modulate:a", 0.0, NOT_CHOSEN_DROP_TIME_SECONDS) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(_on_card_disappeared.bind(card))


func _on_card_disappeared(disappeared_card: Card) -> void:
	displayed_items.erase(disappeared_card.held_item_data)
	
	if not displayed_items.is_empty():
		return
	
	for child in card_row.get_children():
		child.free()
	
	fully_finished_picking_item.emit()
