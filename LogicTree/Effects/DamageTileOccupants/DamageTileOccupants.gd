extends LogicTree


@export var tile_array: LogicTreeTileArrayVariable
@export var damage: LogicTreeIntVariable
@export var output_total_damage: LogicTreeIntVariable


func _ready() -> void:
	assert(tile_array != null, "Tile array variable not set")
	assert(damage != null, "Damage variable not set")


func perform_behavior() -> void:
	var total_damage_dealt: int = 0
	
	for tile in tile_array.value:
		var unit: Unit = tile.occupant as Unit
		if unit == null:
			continue
		
		total_damage_dealt += unit.take_damage(damage.value)
	
	if output_total_damage != null:
		output_total_damage.value = total_damage_dealt
