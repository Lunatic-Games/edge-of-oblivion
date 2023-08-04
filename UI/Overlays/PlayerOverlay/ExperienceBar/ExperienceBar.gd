class_name ExperienceBar
extends ProgressBar


var player: Player = null

@onready var level_up_particles: GPUParticles2D = $LevelUpParticles


func _ready() -> void:
	GlobalSignals.player_spawned.connect(_on_player_spawned)


func _on_player_spawned(spawned_player: Player):
	player = spawned_player
	player.levelling.xp_changed.connect(_on_player_xp_changed)
	player.levelling.levelled_up.connect(_on_player_levelled_up)


func _on_player_xp_changed(_amount: int) -> void:
	var xp_to_next_level: int = player.levelling.get_xp_to_next_level()
	if xp_to_next_level == -1:
		value = max_value
	else:
		var current_xp = player.levelling.current_xp
		var ratio_to_next_level: float = clampf(float(current_xp) / float(xp_to_next_level), 0, 1)
		value = ratio_to_next_level * max_value


func _on_player_levelled_up(_new_level: int) -> void:
	level_up_particles.emitting = true
	var current_xp = player.levelling.current_xp
	var xp_to_next_level: int = player.levelling.get_xp_to_next_level()
	var ratio_to_next_level: float = clampf(float(current_xp) / float(xp_to_next_level), 0, 1)
	value = ratio_to_next_level * max_value
