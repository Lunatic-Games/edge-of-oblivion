class_name NPC
extends Entity


const DIALOGUE_TRIGGER_DATA: EntityData = preload("res://Data/Entities/DialogueTrigger/DialogueTrigger.tres")

var shop_pool: ShopPool = null

@onready var dialogue_start: DS_Start = $DS_Start


func setup(p_data: EntityData, start_tile: Tile = null) -> void:
	super.setup(p_data, start_tile)
	
	var npc_data: NPCData = p_data as NPCData
	if npc_data.shop_pool_data != null:
		shop_pool = ShopPool.new(self, npc_data.shop_pool_data)
	
	if dialogue_start.start_state == null:
		return
	
	try_spawn_dialogue_trigger(start_tile.top_tile)
	try_spawn_dialogue_trigger(start_tile.right_tile)
	try_spawn_dialogue_trigger(start_tile.bottom_tile)
	try_spawn_dialogue_trigger(start_tile.left_tile)


func try_spawn_dialogue_trigger(tile: Tile) -> void:
	if tile == null or tile.occupant != null:
		return
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	var dialogue_trigger: DialogueTrigger = spawn_handler.spawn_entity_on_tile(DIALOGUE_TRIGGER_DATA, tile)
	dialogue_trigger.triggered.connect(_on_dialogue_triggered.bind(dialogue_trigger))


func _on_dialogue_triggered(trigger: DialogueTrigger) -> void:
	dialogue_start.on_enter()
	
	var trigger_tile: Tile = trigger.occupancy.current_tile
	trigger_tile.no_longer_occupied.connect(try_spawn_dialogue_trigger.bind(trigger_tile), CONNECT_ONE_SHOT)
