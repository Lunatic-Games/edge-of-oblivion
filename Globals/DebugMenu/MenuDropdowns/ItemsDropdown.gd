extends MenuDropdownButton


var loaded_item_data: Dictionary = {}  # Name : loaded resource
var item_buttons: Dictionary = {}  # Loaded resource : button 


func setup() -> void:
	var item_data_paths = Utility.get_all_files_under_folder("res://Data/Items", ".tres")
	
	for path in item_data_paths:
		var display_name: String = path.get_file().trim_suffix(".tres")
		
		loaded_item_data[display_name] = load(path)
	
	var item_names: Array = loaded_item_data.keys()
	item_names.sort()
	
	for item_name in item_names:
		var item_data: ItemData = loaded_item_data[item_name]
		var display_name: String = _get_display_name_for_item(null, item_data)
		var button: Button = add_to_menu(display_name, _give_player_item.bind(item_data))
		item_buttons[item_data] = button
	
	GlobalSignals.item_added_to_inventory.connect(_on_item_added_to_inventory)
	GlobalSignals.item_increased_tier.connect(_on_item_increased_tier)


func _give_player_item(item_data: ItemData):
	if not GlobalGameState.player:
		return
	
	GlobalGameState.player.inventory.gain_item(item_data)


func _on_item_added_to_inventory(item: Item, item_data: ItemData):
	item_buttons[item_data].text = _get_display_name_for_item(item, item_data)


func _on_item_increased_tier(item: Item, item_data: ItemData):
	if item.is_max_tier():
		item_buttons[item_data].queue_free()
		return
	
	item_buttons[item_data].text = _get_display_name_for_item(item, item_data)


func _get_display_name_for_item(item: Item, item_data: ItemData) -> String:
	if item == null:
		return item_data.item_name
	
	match item.current_tier:
		1:
			return item_data.item_name + " (II)"
		2:
			return item_data.item_name + " (III)"
		_:
			return item_data.item_name + " (" + str(item.current_tier + 1) + ")"
