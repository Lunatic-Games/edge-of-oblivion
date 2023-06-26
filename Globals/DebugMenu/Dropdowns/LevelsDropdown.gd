extends MenuDropdownButton


const LEVELS_FOLDER = "res://Data/Occupants/Enemies"
const EXCLUDED_LEVEL_NAMES = ["Level"]

var loaded_levels: Dictionary = {}  # Name : loaded scene


func setup() -> void:
	var level_paths = FileUtility.get_all_files_under_folder("res://Data/Levels", ".tscn")
	
	for path in level_paths:
		var display_name: String = path.get_file().trim_suffix(".tscn")
		if EXCLUDED_LEVEL_NAMES.has(display_name):
			continue
		
		loaded_levels[display_name] = load(path)
	
	for level_name in loaded_levels:
		add_to_menu(level_name, change_to_level.bind(loaded_levels[level_name]))


func change_to_level(level_scene: PackedScene):
	LevelLoading.load_level(get_tree(), level_scene)
