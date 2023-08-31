class_name Player
extends Entity


# If changed make sure to update LevelData persistence settings
enum PersistenceSettings {
	HEALTH = 1,
	ITEMS = 2,
	GOLD = 4,
	XP = 8
}

var input_controller: InputController = null
var inventory: Inventory = null
var levelling: Levelling = null


func setup(p_data: EntityData, start_tile: Tile = null) -> void:
	super.setup(p_data, start_tile)
	
	var player_data: PlayerData = p_data as PlayerData
	input_controller = InputController.new(self, player_data.input_controller_data)
	inventory = Inventory.new(self, player_data.inventory_data)
	levelling = Levelling.new(self, player_data.levelling_data)
	
	health.value_changed.connect(_on_health_changed)


func reset(persistence: int):
	if persistence & PersistenceSettings.HEALTH == 0:
		health.reset()
	if persistence & PersistenceSettings.ITEMS == 0:
		inventory.reset_items()
	if persistence & PersistenceSettings.GOLD == 0:
		inventory.reset_gold()
	if persistence & PersistenceSettings.XP == 0:
		levelling.reset()


func _on_health_changed(amount: int) -> void:
	if amount > 0:
		GlobalSignals.player_healed.emit(self, amount)
