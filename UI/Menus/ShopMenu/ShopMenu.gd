class_name ShopMenu
extends CanvasLayer


signal closed

const CARD_SCENE: PackedScene = preload("res://UI/Elements/Card/Card.tscn")

@onready var card_container: Container = $MarginContainer/ScrollContainer/VBoxContainer/GridContainer



func open(items_to_offer: Array[ItemData]) -> void:
	for card in card_container.get_children():
		card.queue_free()
	
	for item_data in items_to_offer:
		var card: Card = CARD_SCENE.instantiate()
		card_container.add_child(card)
		card.setup(item_data, 1)
		card.show_cost()
		card.selected.connect(_on_card_selected.bind(card))
	
	update_card_availabilities()


func update_card_availabilities():
	var game: Game = GlobalGameState.get_game()
	var player: Player = GlobalGameState.get_player()
	if game == null or player == null:
		return
		
	var item_deck: Array[ItemData] = game.item_deck
	var held_gold = player.inventory.gold
	
	for card in card_container.get_children():
		card = card as Card
		if item_deck.has(card.held_item_data) == true:
			card.lock("ACQUIRED")
		elif card.held_item_data.shop_cost > held_gold:
			card.lock("NOT ENOUGH GOLD")
		else:
			card.un_lock()


func _on_card_selected(card: Card):
	var game: Game = GlobalGameState.get_game()
	if game == null:
		return
	
	var item_deck: Array[ItemData] = game.item_deck
	var selected_item_data: ItemData = card.held_item_data
	assert(item_deck.has(selected_item_data) == false, "Trying to add duplicate card to item deck")
	
	item_deck.append(selected_item_data)
	update_card_availabilities()


func _on_back_button_pressed() -> void:
	hide()
	closed.emit()
