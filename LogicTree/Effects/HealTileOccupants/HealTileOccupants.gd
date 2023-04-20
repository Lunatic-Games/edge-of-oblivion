extends LogicTree


@export var tile_array: LogicTreeTileArrayVariable
@export var heal_amount: LogicTreeIntVariable
@export var output_total_healed: LogicTreeIntVariable


func _ready() -> void:
	assert(tile_array != null, "Tile array variable not set")
	assert(heal_amount != null, "Health variable not set")


func perform_behavior() -> void:
	var total_healed: int = 0
	
	for tile in tile_array.value:
		var unit: Unit = tile.occupant as Unit
		if unit == null:
			continue
		
		total_healed += unit.heal(heal_amount.value)
	
	if output_total_healed != null:
		output_total_healed.value = total_healed

