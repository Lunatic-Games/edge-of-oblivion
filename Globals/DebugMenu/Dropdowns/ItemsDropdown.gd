extends MenuDropdownButton


const ITEMS_FOLDER: String = "res://Data/Items"

var item_buttons: Dictionary = {}  # Loaded resource : button 


func setup() -> void:
	var item_data_paths = FileUtility.get_all_files_under_folder(ITEMS_FOLDER, ".tres")
	
	var loaded_items: Array[ItemData] = []
	for path in item_data_paths:
		loaded_items.append(load(path))
	
	for item_data in loaded_items:
		var display_name: String = _get_display_name_for_item(null, item_data)
		var button: Button = add_to_menu(display_name, _give_player_item.bind(item_data))
		item_buttons[item_data] = button
	
	GlobalSignals.player_spawned.connect(_on_player_spawned)
	GlobalSignals.item_added_to_inventory.connect(_on_item_added_to_inventory)
	GlobalSignals.item_increased_tier.connect(_on_item_increased_tier)


func _give_player_item(item_data: ItemData) -> void:
	if not GlobalGameState.player:
		return
	
	GlobalGameState.player.inventory.gain_item(item_data)


func _on_player_spawned(_player: Player) -> void:
	for item_data in item_buttons:
		var button: Button = item_buttons[item_data]
		button.text = _get_display_name_for_item(null, item_data)
		button.show()


func _on_item_added_to_inventory(item: Item, item_data: ItemData) -> void:
	item_buttons[item_data].text = _get_display_name_for_item(item, item_data)


func _on_item_increased_tier(item: Item, item_data: ItemData) -> void:
	if item.is_max_tier():
		item_buttons[item_data].hide()
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
