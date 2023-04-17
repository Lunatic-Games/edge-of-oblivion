extends LogicTree


@export var input_item: Item
@export var item_array: LogicTreeItemArrayVariable
@export var entity_array: LogicTreeEntityArrayVariable
@export var tile_array: LogicTreeTileArrayVariable


func _ready() -> void:
	assert(input_item != null, "Input item not set")


func perform_behavior() -> void:
	if item_array != null:
		item_array.value = [input_item]
	
	if entity_array != null:
		if input_item.user != null:
			entity_array.value = [input_item.user]
		else:
			entity_array.value = []
	
	if tile_array != null:
		var unit: Unit = input_item.user as Unit
		if unit != null and unit.current_tile != null:
			tile_array.value = [unit.current_tile]
		else:
			tile_array.value = []
	
	
