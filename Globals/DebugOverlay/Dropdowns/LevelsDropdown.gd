extends MenuDropdownButton


const LEVELS_FOLDER = "res://Data/Levels"

var loaded_levels: Array[LevelData] = []


func setup() -> void:
	var level_paths = FileUtility.get_all_files_under_folder(LEVELS_FOLDER, ".tres")
	
	for path in level_paths:
		var level_data: LevelData = load(path) as LevelData
		if level_data == null:
			continue
		
		loaded_levels.append(level_data)
	
	for level_data in loaded_levels:
		add_to_menu(level_data.level_name, change_to_level.bind(level_data))


func change_to_level(level_data: LevelData):
	LevelLoading.load_level(get_tree(), level_data)
