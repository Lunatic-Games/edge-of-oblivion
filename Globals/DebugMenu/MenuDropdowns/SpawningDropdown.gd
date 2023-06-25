extends MenuDropdownButton


const EXCLUDED_ENEMY_NAMES = ["Boss", "Enemy"]

var loaded_enemies: Dictionary = {}  # Name : loaded scene


func setup() -> void:
	var enemy_paths = Utility.get_all_files_under_folder("res://Data/Occupants/Enemies", ".tscn")
	for path in enemy_paths:
		var display_name: String = path.get_file().trim_suffix(".tscn")
		if EXCLUDED_ENEMY_NAMES.has(display_name):
			continue
		
		loaded_enemies[display_name] = load(path)
	
	var enemy_names: Array = loaded_enemies.keys()
	enemy_names.sort()
	
	for enemy_name in enemy_names:
		add_to_menu(enemy_name, _spawn_enemy_scene.bind(loaded_enemies[enemy_name]))


func _spawn_enemy_scene(scene: PackedScene):
	if GlobalGameState.board == null or GlobalGameState.game == null:
		return
	
	var tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	if tile == null:
		return
	
	GlobalGameState.game.spawn_handler.spawn_enemy_on_tile(scene, tile)
