@icon("res://Assets/art/dialogue-state/hammer.png")
class_name DS_OpenForge
extends DialogueState


@export var state_after_closing: DialogueState = null


func _ready() -> void:
	assert(state_after_closing != null, "State after closing is not specified for '" + name + "'")


func on_enter():
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	var game: Game = GlobalGameState.get_game()
	if game == null or dialogue_overlay == null:
		return
	
	dialogue_overlay.close()
	
	var items_to_forge: Array[ItemData] = []
	for item_data in game.item_deck:
		items_to_forge.append(item_data)
	game.forge_menu.open(items_to_forge)
	game.forge_menu.closed.connect(_on_forge_closed, CONNECT_ONE_SHOT)



func _on_forge_closed() -> void:
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	if dialogue_overlay != null:
		dialogue_overlay.open()
	
	transition(state_after_closing)
