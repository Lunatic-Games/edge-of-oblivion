class_name ShopPoolData
extends Resource


@export var item_pool: Array[ItemData] = []
@export_range(1, 12, 1, "or_greater") var max_n_items_to_offer: int = 6


func generate_selection() -> Array[ItemData]:
	var randomized: Array[ItemData] = []
	randomized.append_array(item_pool)
	randomized.shuffle()
	
	return randomized.slice(0, max_n_items_to_offer)
