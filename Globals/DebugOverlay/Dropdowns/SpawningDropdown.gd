extends MenuDropdownButton


const ENEMIES_FOLDER = "res://Data/Occupants/Enemies"
const EXCLUDED_ENEMY_NAMES = ["Boss", "Enemy"]

var loaded_normal_enemies: Array[EnemyData] = []
var loaded_bosses: Array[EnemyData] = []

var enemy_to_spawn_on_tile_selected: EnemyData = null
var random_toggle_button: Button = null
var random_spawning_enabled: bool = false


func setup() -> void:
	_load_enemies()
	
	random_toggle_button = add_to_menu("Random tile: ☐", _random_toggle_pressed)
	add_spacer()

	for enemy_data in loaded_normal_enemies:
		add_to_menu(enemy_data.enemy_name, _on_enemy_button_pressed.bind(enemy_data))
	
	add_spacer()
	
	for enemy_data in loaded_bosses:
		add_to_menu(enemy_data.enemy_name, _on_enemy_button_pressed.bind(enemy_data))


func _random_toggle_pressed():
	random_spawning_enabled = !random_spawning_enabled
	
	if random_spawning_enabled:
		random_toggle_button.text = "Random tile: ☑"
	else:
		random_toggle_button.text = "Random tile: ☐"


func _on_enemy_button_pressed(enemy_data: EnemyData):
	if random_spawning_enabled:
		_spawn_enemy_on_random_tile(enemy_data)
	else:
		enemy_to_spawn_on_tile_selected = enemy_data
		GlobalDebugOverlay.select_tiles_menu.begin_selection(_spawn_enemy_on_selected_tile,
			"Select Tiles to Spawn " + enemy_data.enemy_name + " on")


func _spawn_enemy_on_selected_tile(tile: Tile):
	if tile == null or GlobalGameState.board == null or GlobalGameState.game == null:
		return
	
	if tile.occupant != null and tile.occupant.occupant_type == tile.occupant.OccupantType.BLOCKING:
		return
	
	GlobalGameState.game.spawn_handler.spawn_enemy_on_tile(enemy_to_spawn_on_tile_selected, tile)


func _spawn_enemy_on_random_tile(enemy_data: EnemyData):
	if GlobalGameState.board == null or GlobalGameState.game == null:
		return
	
	var tile: Tile = GlobalGameState.board.get_random_unoccupied_tile()
	if tile == null:
		return
	
	GlobalGameState.game.spawn_handler.spawn_enemy_on_tile(enemy_data, tile)


func _load_enemies():
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
