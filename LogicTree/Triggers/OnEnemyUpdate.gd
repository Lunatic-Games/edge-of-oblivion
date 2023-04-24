@icon("res://Assets/art/logic-tree/triggers/update.png")
class_name LT_OnEnemyUpdate
extends LogicTreeTrigger


@export var enemy: Enemy
@export var output_enemy_entity: LT_EntityArrayVariable
@export var output_enemy_tile: LT_TileArrayVariable
@export var output_player_entity: LT_EntityArrayVariable
@export var output_player_tile: LT_TileArrayVariable


func _ready() -> void:
	super._ready()
	assert(enemy != null, "Enemy not set for '" + name + "'")
	enemy.update_triggered.connect(trigger)


func trigger() -> void:
	if output_enemy_entity != null:
		output_enemy_entity.value = [enemy]
	
	if output_enemy_tile != null:
		if enemy.current_tile != null:
			output_enemy_tile.value = [enemy.current_tile]
		else:
			output_enemy_tile.value.clear()
	
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
	
	logic_tree_on_trigger.evaluate()
