@icon("res://Assets/art/dialogue-state/plus.png")
class_name DS_AddToRunDeck
extends DialogueState


@export var item_to_add: ItemData = null
@export var next_state: DialogueState = null


func _ready() -> void:
	assert(item_to_add != null, "Item to add is not specified for '" + name + "'")
	assert(next_state != null, "Next state is not specified for '" + name + "'")


func on_enter():
	var game: Game = GlobalGameState.get_game()
	assert(game.item_deck.has(item_to_add) == false, "Probably need a DS_IfDeckHasItem or something...")
	
	game.item_deck[item_to_add] = 1
	transition(next_state)
