extends CanvasLayer


@export var default_start_scene: PackedScene
@export var web_start_scene: PackedScene

@export_group("Debug build")
@export var debug_start_scene: PackedScene
@export var debug_load_save_file: bool = false


func _ready() -> void:
	assert(default_start_scene != null, "No default start scene set")
	
	if !OS.is_debug_build() or debug_load_save_file:
		Saving.load_from_file()
	
	if OS.is_debug_build() and debug_start_scene != null:
		get_tree().change_scene_to_packed(debug_start_scene)
	elif OS.has_feature("web") and web_start_scene != null:
		get_tree().change_scene_to_packed(web_start_scene)
	else:
		get_tree().change_scene_to_packed(default_start_scene)
