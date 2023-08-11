class_name Gateway
extends Entity


var destination: LevelData = null


func setup(p_data: EntityData) -> void:
	super.setup(p_data)
	occupancy.collected.connect(_on_collected)


func set_destination(gateway_destination: LevelData) -> void:
	destination = gateway_destination


func _on_collected(_by) -> void:
	assert(destination != null, "Gateway does not have a destination set")
	var game: Game = GlobalGameState.get_game()
	game.queued_level_transition = destination
