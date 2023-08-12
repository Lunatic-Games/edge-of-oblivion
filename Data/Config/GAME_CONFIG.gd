class_name GameConfig
extends Resource


enum PrecacheSettings {
	NEVER,
	ALWAYS,
	RELEASE_BUILDS,
	WEB_BUILDS
}

@export var starting_level_data: LevelData
@export var precache: PrecacheSettings = PrecacheSettings.WEB_BUILDS

@export_group("Window")
@export var min_window_size: Vector2i = Vector2i(800, 600)

@export_group("Debug")
@export var debug_start_scene: PackedScene
@export var debug_load_progress_save_file: bool = false
@export var debug_load_settings_save_file: bool = false
