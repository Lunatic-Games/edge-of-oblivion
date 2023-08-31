@icon("res://Assets/art/dialogue-state/money.png")
class_name DS_OpenShop
extends DialogueState


@export var state_after_closing: DialogueState = null


func _ready() -> void:
	assert(state_after_closing != null, "State after closing is not specified for '" + name + "'")


func on_enter():
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	var game: Game = GlobalGameState.get_game()
	if game == null or dialogue_overlay == null:
		return
	
	var npc: NPC = owner as NPC
	assert(npc != null, "OpenShop is currently only supported on NPCs")
	
	dialogue_overlay.close()
	
	if npc.shop_pool != null:
		game.shop_menu.open(npc.shop_pool.items)
	else:
		game.shop_menu.open([])
	game.shop_menu.closed.connect(_on_shop_closed, CONNECT_ONE_SHOT)



func _on_shop_closed() -> void:
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	if dialogue_overlay != null:
		dialogue_overlay.open()
	
	transition(state_after_closing)
