class_name GoldStorage
extends RefCounted


const GOLD_PICKUP_DATA: EntityData = preload("res://Data/Entities/GoldPickup/GoldPickup.tres")
const HOLDING_GOLD_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/HoldingGold/HoldingGold.tscn")

var entity: Entity = null
var data: GoldStorageData = null

var particles_added: bool = false
var stored_gold: int = 0  # Make sure to use method below if collecting


func _init(p_entity: Entity, p_data: GoldStorageData):
	entity = p_entity
	data = p_data
	stored_gold += p_data.generate_gold()
	if entity.health != null:
		entity.health.died.connect(_on_died)


func add_collected_gold(amount: int = 0) -> void:
	assert(amount >= 0, "Negative gold being collected")
	if amount <= 0:
		return
	
	stored_gold += amount
	if particles_added == false and data.add_particles_on_collecting_gold == true:
		var particles: GPUParticles2D = HOLDING_GOLD_PARTICLES_SCENE.instantiate()
		entity.add_child(particles)
		particles.emitting = true
		particles_added = true


func _on_died(_source: int = 0):
	if stored_gold == 0:
		return
	
	var tile_died_on: Tile = entity.occupancy.current_tile
	if tile_died_on == null:
		return
		
	assert(tile_died_on.occupant != entity, "Need to handle gold dropping on tile with entity already on it")
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	if spawn_handler == null:
		return
	
	var gold_pickup: GoldPickup = spawn_handler.spawn_entity_on_tile(GOLD_PICKUP_DATA, tile_died_on) as GoldPickup
	gold_pickup.gold_amount = stored_gold
