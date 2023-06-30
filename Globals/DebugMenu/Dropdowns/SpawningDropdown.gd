extends MenuDropdownButton


const ENEMIES_FOLDER = "res://Data/Occupants/Enemies"
const BOSSES_FOLDER = "res://Data/Occupants/Enemies/Bosses"  # Expected to be under ENEMIES_FOLDER
const EXCLUDED_ENEMY_NAMES = ["Boss", "Enemy"]

var loaded_normal_enemies: Dictionary = {}  # Name : loaded scene
var loaded_bosses: Dictionary = {}  # Name : loaded scene


func setup() -> void:
	var enemy_paths = FileUtility.get_all_files_under_folder("res://Data/Occupants/Enemies", ".tscn")
	for path in enemy_paths:
		var is_boss: bool = path.contains(BOSSES_FOLDER)
		var display_name: String = path.get_file().trim_suffix(".tscn")
		if EXCLUDED_ENEMY_NAMES.has(display_name):
			continue
		
		if is_boss:
			loaded_bosses[display_name] = load(path)
		else:
			loaded_normal_enemies[display_name] = load(path)
	
	for enemy_name in loaded_normal_enemies:
		add_to_menu(enemy_name, _spawn_enemy_scene.bind(loaded_normal_enemies[enemy_name]))
	
	add_spacer()
	
	for boss_name in loaded_bosses:
		add_to_menu(boss_name, _spawn_enemy_scene.bind(loaded_bosses[boss_name]))


func _spawn_enemy_scene(scene: PackedScene):
	if GlobalGameState.board == null or GlobalGameState.game == null:
		return
	
	var tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	if tile == null:
		return
	
	GlobalGameState.game.spawn_handler.spawn_enemy_on_tile(scene, tile)
