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
		"account_xp": GlobalAccount.xp,
		"account_stats": JSON.stringify(GlobalAccountStatTracker.stats)
	}
	
	print(save_data)
	
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
	
	var dict: Dictionary = JSON.parse_string(f.get_line())
	if dict == null:
		return
	
	GlobalAccount.level = dict.get("account_level", 1)
	GlobalAccount.xp = dict.get("account_xp", 0)
	var saved_stats = JSON.parse_string(dict.get("account_stats", ""))
	if saved_stats:
		for key in saved_stats:
			if GlobalAccountStatTracker.stats.has(key):
				GlobalAccountStatTracker.stats[key] = saved_stats[key]
	
	var unlocked_item_data_paths: Array = dict.get("unlocked_items", []) as Array
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
		"master_volume": _get_audio_bus_value("Master"),
		"music_volume": _get_audio_bus_value("Music"),
		"sfx_volume": _get_audio_bus_value("SFX"),
		"fullscreen": DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
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
	
	var dict: Dictionary = JSON.parse_string(f.get_line())
	if dict == null:
		return
	
	var master_volume: int = dict.get("master_volume", 100)
	var music_volume: int = dict.get("music_volume", 100)
	var sfx_volume: int = dict.get("sfx_volume", 100)
	var fullscreen_enabled: bool = dict.get("fullscreen", false)
	
	_load_audio_bus("Master", master_volume)
	_load_audio_bus("Music", music_volume)
	_load_audio_bus("SFX", sfx_volume)
	
	if fullscreen_enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	# Otherwise will default to project settings


static func _load_audio_bus(bus_name: String, volume_out_of_100: int) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(float(volume_out_of_100) / 100.0))


# Returns out of 100
static func _get_audio_bus_value(bus_name: String) -> int:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var db: float = AudioServer.get_bus_volume_db(bus_index)
	return int(db_to_linear(db) * 100.0)
