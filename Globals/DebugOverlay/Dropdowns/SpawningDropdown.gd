extends MenuDropdownButton


const ENEMIES_FOLDER = "res://Data/Occupants/Enemies"
const EXCLUDED_ENEMY_NAMES = ["Boss", "Enemy"]

var loaded_normal_enemies: Array[EnemyData] = []
var loaded_bosses: Array[EnemyData] = []


func setup() -> void:
	var enemy_paths = FileUtility.get_all_files_under_folder("res://Data/Occupants/Enemies", ".tres")
	for path in enemy_paths:
		var display_name: String = path.get_file().trim_suffix(".tres")
		if EXCLUDED_ENEMY_NAMES.has(display_name):
			continue
		
		var enemy_data: EnemyData = load(path)
		
		if enemy_data.is_boss:
			loaded_bosses.append(enemy_data)
		else:
			loaded_normal_enemies.append(enemy_data)
	
	for enemy_data in loaded_normal_enemies:
		add_to_menu(enemy_data.enemy_name, _spawn_enemy_scene.bind(enemy_data))
	
	add_spacer()
	
	for enemy_data in loaded_bosses:
		add_to_menu(enemy_data.enemy_name, _spawn_enemy_scene.bind(enemy_data))


func _spawn_enemy_scene(enemy_data: EnemyData):
	if GlobalGameState.board == null or GlobalGameState.game == null:
		return
	
	var tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	if tile == null:
		return
	
	GlobalGameState.game.spawn_handler.spawn_enemy_on_tile(enemy_data, tile)
