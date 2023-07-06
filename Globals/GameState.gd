extends Node


var in_upgrade_menu: bool = false
var game_ended: bool = false

var game: Game = null
var board: Board = null
var player: Player = null


func _ready() -> void:
	GlobalSignals.player_spawned.connect(_on_player_spawned)


func new_game(the_new_game: Game) -> void:
	game_ended = false
	game = the_new_game
	board = game.level.board
	in_upgrade_menu = false


func _on_player_spawned(spawned_player: Player):
	player = spawned_player
