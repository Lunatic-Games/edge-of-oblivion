class_name GameModeData
extends Resource


@export var show_player_ui_overlay: bool = true
@export var update_items: bool = true
@export var increment_round_number: bool = true

@export_group("Phase durations")
@export_range(0.0, 1.0, 0.01, "or_greater") var move_phase_duration_seconds: float = 0.05
@export_range(0.0, 1.0, 0.01, "or_greater") var item_phase_duration_seconds: float = 0.15
@export_range(0.0, 1.0, 0.01, "or_greater") var tile_phase_duration_seconds: float = 0.0
@export_range(0.0, 1.0, 0.01, "or_greater") var enemy_phase_duration_seconds: float = 0.15
@export_range(0.0, 1.0, 0.01, "or_greater") var enemy_spawn_phase_duration_seconds: float = 0.1
@export_range(0.0, 1.0, 0.01, "or_greater") var spawn_flag_phase_duration_seconds: float = 0.1


func get_total_process_time() -> float:
	return move_phase_duration_seconds + item_phase_duration_seconds + \
		tile_phase_duration_seconds + enemy_phase_duration_seconds + \
		enemy_spawn_phase_duration_seconds + spawn_flag_phase_duration_seconds
