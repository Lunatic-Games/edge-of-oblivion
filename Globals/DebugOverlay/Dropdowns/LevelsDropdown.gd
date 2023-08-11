extends MenuDropdownButton


const GAME_SCENE: PackedScene = preload("res://Game/Game.tscn")
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
	var scene_tree: SceneTree = get_tree()
	var current_scene: Node = scene_tree.current_scene
	scene_tree.root.remove_child(current_scene)
	current_scene.queue_free()
	
	await scene_tree.process_frame
	
	var game: Game = GAME_SCENE.instantiate()
	game.level_data = level_data
	scene_tree.root.add_child(game)
	scene_tree.current_scene = game
