class_name CardDisplay
extends HBoxContainer


signal card_selected
signal finished_animating_selection

const CARD_SCENE: PackedScene = preload("res://UI/Elements/Card/Card.tscn")
const DISPLAY_FLOAT_UP_DISTANCE: float = 200.0
const DISPLAY_FLOAT_UP_TIME_SECONDS: float = 0.5
const DISPLAY_DELAY_BETWEEN_CARDS_SECONDS: float = 0.2

const NOT_CHOSEN_DROP_DISTANCE: float = 200.0
const NOT_CHOSEN_DROP_TIME_SECONDS: float = 0.5

const CHOSEN_RISE_DISTANCE: float = 50.0
const CHOSEN_RISE_TIME_SECONDS: float = 1.0


var n_cards_waiting_to_disappear: int = 0


func display_items(items: Array[ItemData]):
	var float_up_delay: float = 0.0
	for item_data in items:
		_add_card_to_display(item_data, float_up_delay)
		float_up_delay += DISPLAY_DELAY_BETWEEN_CARDS_SECONDS


func _add_card_to_display(item_data: ItemData, float_up_delay: float = 0.0) -> void:
	var card: Card = CARD_SCENE.instantiate()
	add_child(card)
	
	var player: Player = GlobalGameState.get_player()
	var item_tier: int = 1
	if player != null and item_data in player.inventory.items:
		item_tier = player.inventory.items[item_data].current_tier + 1
	
	card.setup(item_data, item_tier, true)
	card.selected.connect(_on_card_selected.bind(card))
	_float_card_up(card, float_up_delay)


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
	card_selected.emit()
	
	for child in get_children():
		var card: Card = child as Card
		assert(card != null, "Card row should only contain cards")
		card.selected.disconnect(_on_card_selected)
		
		if card == selected_card:
			var player: Player = GlobalGameState.get_player()
			if player != null:
				player.inventory.add_or_upgrade_item(card.held_item_data)
			_raise_chosen_card(card)
		else:
			_drop_unchosen_card(card)


func _raise_chosen_card(card: Card) -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(card, "position:y", -CHOSEN_RISE_DISTANCE, CHOSEN_RISE_TIME_SECONDS) \
		.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(card, "modulate:a", 0.0, CHOSEN_RISE_TIME_SECONDS) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(_on_card_disappeared)
	n_cards_waiting_to_disappear += 1


func _drop_unchosen_card(card: Card) -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(card, "position:y", NOT_CHOSEN_DROP_DISTANCE, NOT_CHOSEN_DROP_TIME_SECONDS) \
		.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(card, "modulate:a", 0.0, NOT_CHOSEN_DROP_TIME_SECONDS) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(_on_card_disappeared)
	n_cards_waiting_to_disappear += 1


func _on_card_disappeared() -> void:
	n_cards_waiting_to_disappear -= 1
	
	if n_cards_waiting_to_disappear > 0:
		return
	
	for child in get_children():
		remove_child(child)
		child.free()
	
	finished_animating_selection.emit()
