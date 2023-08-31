class_name ShopMenu
extends CanvasLayer


signal closed

const CARD_SCENE: PackedScene = preload("res://UI/Elements/Card/Card.tscn")

@onready var card_container: Container = $MarginContainer/ScrollContainer/VBoxContainer/GridContainer
@onready var gold_display: GoldDisplay = $MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/HBoxContainer/GoldDisplay



func open(items_to_offer: Array[ItemData]) -> void:
	for card in card_container.get_children():
		card.queue_free()
	
	for item_data in items_to_offer:
		var card: Card = CARD_SCENE.instantiate()
		card_container.add_child(card)
		card.setup(item_data, 1, 1)
		card.show_cost(1)
		card.selected.connect(_on_card_selected.bind(card))
	
	update_card_availabilities()
	update_gold_display(false)
	show()


func update_card_availabilities():
	var game: Game = GlobalGameState.get_game()
	var player: Player = GlobalGameState.get_player()
	if game == null or player == null:
		return
		
	var item_deck: Dictionary = game.item_deck
	var held_gold = player.inventory.gold
	
	for card in card_container.get_children():
		card = card as Card
		var data: ItemData = card.held_item_data
		
		if item_deck.has(data) == true:
			card.lock("ACQUIRED")
		elif data.get_cost(1) > held_gold:
			card.lock("NOT ENOUGH GOLD")
		else:
			card.un_lock()


func update_gold_display(animate: bool = true):
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	var held_gold = player.inventory.gold
	gold_display.set_display_amount(held_gold, animate)


func _on_card_selected(card: Card):
	var game: Game = GlobalGameState.get_game()
	var player: Player = GlobalGameState.get_player()
	if game == null or player == null:
		return
	
	var item_deck: Dictionary = game.item_deck
	var selected_item_data: ItemData = card.held_item_data
	assert(item_deck.has(selected_item_data) == false, "Trying to add duplicate card to item deck")
	
	item_deck[selected_item_data] = 1
	player.inventory.add_or_remove_gold(-selected_item_data.get_cost(1))
	update_card_availabilities()
	update_gold_display()


func _on_back_button_pressed() -> void:
	hide()
	closed.emit()
