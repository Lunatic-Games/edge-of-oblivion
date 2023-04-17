extends LogicTree


@export var tile_array: LogicTreeTileArrayVariable
@export var damage: LogicTreeIntVariable


func _ready() -> void:
	assert(tile_array != null, "Tile array variable not set")
	assert(damage != null, "Damage variable not set")


func perform_behavior() -> void:
	for tile in tile_array.value:
		var unit: Unit = tile.occupant as Unit
		if unit == null:
			continue
		
		unit.take_damage(damage.value)
