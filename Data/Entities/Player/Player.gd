class_name Player
extends Entity


var input_controller: InputController = null
var inventory: Inventory = null
var levelling: Levelling = null


func setup(p_data: EntityData) -> void:
	var player_data: PlayerData = p_data as PlayerData
	input_controller = InputController.new(self, player_data.input_controller_data)
	inventory = Inventory.new(self, player_data.inventory_data)
	levelling = Levelling.new(self, player_data.levelling_data)
	super.setup(p_data)
