extends Node


var _game: Game = null
var _spawn_handler: SpawnHandler = null
var _board: Board = null
var _player: Player = null


func _ready() -> void:
	GlobalSignals.initial_level_setup_completed.connect(_on_initial_level_setup_completed)
	GlobalSignals.player_spawned.connect(_on_player_spawned)


func get_game() -> Game:
	return _game


func get_spawn_handler() -> SpawnHandler:
	return _spawn_handler


func get_board() -> Board:
	return _board


func get_player() -> Player:
	return _player


func _on_initial_level_setup_completed(game: Game) -> void:
	_game = game
	_spawn_handler = game.spawn_handler
	_board = game.level.board


func _on_player_spawned(spawned_player: Player) -> void:
	_player = spawned_player
