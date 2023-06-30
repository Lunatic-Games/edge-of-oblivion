class_name Saving
extends Node


const SAVE_PROGRESS_VERSION = 1  # Increment when becomes incompatible
const SAVE_PROGRESS_PATH = "user://progress.save"
const SAVE_PROGRESS_PASSPHRASE = "EOO"

const SAVE_SETTINGS_VERSION = 1  # Increment when becomes incompatible
const SAVE_SETTINGS_PATH = "user://settings.txt"


static func save_progress_to_file():
	var f: FileAccess = FileAccess.open_encrypted_with_pass(SAVE_PROGRESS_PATH, FileAccess.WRITE,
		SAVE_PROGRESS_PASSPHRASE)
	
	if f == null:
		return
	
	var unlocked_item_data_paths: Array[String] = []
	for item_data in GlobalAccount.unlocked_items:
		unlocked_item_data_paths.append(item_data.resource_path)
	
	var save_data: Dictionary = {
		"unlocked_items": unlocked_item_data_paths,
		"account_level": GlobalAccount.level,
		"account_xp": GlobalAccount.xp
	}
	
	f.store_line(str(SAVE_PROGRESS_VERSION))
	f.store_line(JSON.stringify(save_data))


static func load_progress_from_file():
	var f: FileAccess = FileAccess.open_encrypted_with_pass(SAVE_PROGRESS_PATH, FileAccess.READ,
		SAVE_PROGRESS_PASSPHRASE)
	
	if f == null or f.get_position() > f.get_length():
		return
	
	var save_version_string: String = f.get_line()
	if !save_version_string.is_valid_int() or int(save_version_string) != SAVE_PROGRESS_VERSION:
		return
	
	if f.get_position() > f.get_length():
		return
	
	var json_parse: Dictionary = JSON.parse_string(f.get_line())
	if json_parse == null:
		return
	
	GlobalAccount.level = json_parse.get("account_level", 1)
	GlobalAccount.xp = json_parse.get("account_xp", 0)
	
	var unlocked_item_data_paths: Array = json_parse.get("unlocked_items", []) as Array
	for item_data_path in unlocked_item_data_paths:
		var item_data: ItemData = load(item_data_path) as ItemData
		if item_data == null:
			continue
		
		if not GlobalAccount.unlocked_items.has(item_data):
			GlobalAccount.unlocked_items.append(item_data)
	
	GlobalSignals.save_loaded.emit()


static func save_user_settings_to_file():
	var f: FileAccess = FileAccess.open(SAVE_SETTINGS_PATH, FileAccess.WRITE)
	
	if f == null:
		return
	
	var save_data: Dictionary = {
		"master_volume": 100,
		"music_volume": 100,
		"sfx_volume": 100,
		"resolution_width": 1280,
		"resolution_height": 720,
		"fullscreen": true
	}
	
	f.store_line(str(SAVE_SETTINGS_VERSION))
	f.store_line(JSON.stringify(save_data))


static func load_user_settings_from_file():
	var f: FileAccess = FileAccess.open(SAVE_SETTINGS_PATH, FileAccess.READ)
	
	if f == null:
		return
	
	var save_version_string: String = f.get_line()
	if !save_version_string.is_valid_int() or int(save_version_string) != SAVE_SETTINGS_VERSION:
		return
	
	var json_parse: Dictionary = JSON.parse_string(f.get_line())
	if json_parse == null:
		return
