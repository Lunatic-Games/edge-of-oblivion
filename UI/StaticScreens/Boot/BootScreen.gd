extends CanvasLayer


const MAIN_MENU_SCENE: PackedScene = preload("res://UI/Menus/MainMenu/MainMenu.tscn")
const PRECACHE_SCENE: PackedScene = preload("res://UI/StaticScreens/Precaching/PrecachingScreen.tscn")

const GAME_CONFIG: GameConfig = preload("res://Data/Config/GameConfig.tres")


func _ready() -> void:
	DisplayServer.window_set_min_size(GAME_CONFIG.min_window_size)
	
	if !OS.is_debug_build() or GAME_CONFIG.debug_load_progress_save_file:
		Saving.load_progress_from_file()
	if !OS.is_debug_build() or GAME_CONFIG.debug_load_settings_save_file:
		Saving.load_user_settings_from_file()
	
	if OS.is_debug_build() and GAME_CONFIG.debug_start_scene != null:
		get_tree().change_scene_to_packed(GAME_CONFIG.debug_start_scene)
		return
	
	match GAME_CONFIG.precache:
		GameConfig.PrecacheSettings.ALWAYS:
			get_tree().change_scene_to_packed(PRECACHE_SCENE)
			return
		GameConfig.PrecacheSettings.WEB_BUILDS:
			if OS.has_feature("web"):
				get_tree().change_scene_to_packed(PRECACHE_SCENE)
				return
		GAME_CONFIG.PrecacheSettings.RELEASE_BUILDS:
			if OS.is_debug_build() == false:
				get_tree().change_scene_to_packed(PRECACHE_SCENE)
				return
	
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
