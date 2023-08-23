class_name InventoryData
extends Resource


@export_range(0, 10, 1, "or_greater") var max_inventory_size: int = 5
@export var starting_items: Array[ItemData]
@export_range(0, 1000, 1, "or_greater") var starting_gold: int = 0
