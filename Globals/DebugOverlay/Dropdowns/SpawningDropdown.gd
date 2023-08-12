extends MenuDropdownButton


const GATEWAY_DATA: EntityData = preload("res://Data/Entities/Gateway/Gateway.tres")

const ENEMIES_FOLDER = "res://Data/Entities/Enemies"
const EXCLUDED_ENEMY_NAMES = ["Boss", "Enemy"]

var loaded_normal_enemies: Array[EnemyData] = []
var loaded_bosses: Array[EnemyData] = []

var entity_to_spawn_on_tile_selected: EntityData = null
var random_toggle_button: Button = null
var random_spawning_enabled: bool = false


func setup() -> void:
	_load_enemies()
	
	random_toggle_button = add_to_menu("Random tile: ☐", _random_toggle_pressed)
	add_spacer()
	
	for enemy_data in loaded_normal_enemies:
		add_to_menu(enemy_data.entity_name, _on_entity_button_pressed.bind(enemy_data))
	add_spacer()
	
	for enemy_data in loaded_bosses:
		add_to_menu(enemy_data.entity_name, _on_entity_button_pressed.bind(enemy_data))


func _random_toggle_pressed():
	random_spawning_enabled = !random_spawning_enabled
	
	if random_spawning_enabled:
		random_toggle_button.text = "Random tile: ☑"
	else:
		random_toggle_button.text = "Random tile: ☐"


func _on_entity_button_pressed(entity_data: EntityData):
	if random_spawning_enabled:
		_spawn_entity_on_random_tile(entity_data)
	else:
		entity_to_spawn_on_tile_selected = entity_data
		GlobalDebugOverlay.select_tiles_menu.begin_selection(_spawn_entity_on_selected_tile,
			"Select Tiles to Spawn " + entity_data.entity_name + " on")


func _spawn_entity_on_selected_tile(tile: Tile):
	if tile == null:
		return
	
	if tile.occupant != null:
		return
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	if spawn_handler == null:
		return
	
	var entity_data: EntityData = entity_to_spawn_on_tile_selected
	spawn_handler.spawn_entity_on_tile(entity_data, tile)


func _spawn_entity_on_random_tile(entity_data: EntityData):
	var board: Board = GlobalGameState.get_board()
	if board == null:
		return
	
	var tile: Tile = board.get_random_unoccupied_tile()
	if tile == null:
		return
	
	var spawn_handler: SpawnHandler = GlobalGameState.get_spawn_handler()
	if spawn_handler == null:
		return
	spawn_handler.spawn_entity_on_tile(entity_data, tile)


func _load_enemies():
	var enemy_paths = FileUtility.get_all_files_under_folder(ENEMIES_FOLDER, ".tres")
	for path in enemy_paths:
		var display_name: String = path.get_file().trim_suffix(".tres")
		if EXCLUDED_ENEMY_NAMES.has(display_name):
			continue
		
		var enemy_data: EnemyData = load(path)
		
		if enemy_data.is_boss():
			loaded_bosses.append(enemy_data)
		else:
			loaded_normal_enemies.append(enemy_data)
