@icon("res://Assets/art/logic-tree/operations/p.png")
class_name LT_GetPlayer
extends LogicTreeGetterOperation


@export var output_player_entity: LT_EntityArrayVariable
@export var output_player_tile: LT_TileArrayVariable
@export var output_player_items: LT_ItemArrayVariable


func perform_behavior() -> void:
	if output_player_entity != null:
		if GameManager.player != null:
			output_player_entity.value = []
		else:
			output_player_entity.value.clear()
	
	if output_player_tile != null:
		if GameManager.player != null and GameManager.player.current_tile != null:
			output_player_tile.value = [GameManager.player.current_tile]
		else:
			output_player_tile.value.clear()
	
	if output_player_items != null:
		output_player_items.value.clear()
		if GameManager.player != null:
			for item in GameManager.player.inventory.items.values():
				output_player_items.value.append(item)
