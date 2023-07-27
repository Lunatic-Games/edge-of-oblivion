extends Camera2D


var tracked_player: Player = null


func _ready() -> void:
	GlobalSignals.player_spawned.connect(_on_player_spawned)


func _process(_delta: float) -> void:
	if is_instance_valid(tracked_player):
		global_position = tracked_player.global_position


func _on_player_spawned(spawned_player: Player) -> void:
	tracked_player = spawned_player
	spawned_player.died.connect(_on_player_died)


func _on_player_died() -> void:
	tracked_player = null
