extends Node


signal levelled_up(new_level: int)
signal reached_max_level(max_level: int)

@export var starting_items: Array[ItemData]
@export var levelling: Array[AccountLevelData]

var unlocked_items: Array[ItemData] = []
var level: int = 1
var xp: int = 0


func _ready() -> void:
	unlocked_items.append_array(starting_items)


func gain_xp(amount: int) -> void:
	xp += amount
	
	var next_level_data_i: int = level - 1  # At level 1 next is level 2 data stored at index 0
	while next_level_data_i < levelling.size():
		var next_level_data: AccountLevelData = levelling[next_level_data_i]
		if xp < next_level_data.xp_cost:
			break
		
		xp -= next_level_data.xp_cost
		level += 1
		unlocked_items.append_array(next_level_data.item_unlocks)
		next_level_data_i += 1
		
		levelled_up.emit(level)
		if next_level_data_i >= levelling.size():
			reached_max_level.emit(level)


func get_items_unlocked_for_current_level() -> Array[ItemData]:
	if level == 1:
		return unlocked_items
	
	var current_level_data_i: int = level - 2  # At level 2 you have unlocked items at index 0
	assert(current_level_data_i < levelling.size(), "Can't get account level data")
	
	return levelling[current_level_data_i].item_unlocks


# Returns -1 if there is no next level
func get_xp_to_next_level() -> int:
	var next_level_data_i: int = level - 1
	if next_level_data_i >= levelling.size():
		return -1
	
	return levelling[next_level_data_i].xp_cost - xp


func get_max_level() -> int:
	return levelling.size() + 1


func is_max_level() -> bool:
	return get_max_level() == level
