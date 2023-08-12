class_name ExperienceBar
extends ProgressBar


const VALUE_UPDATE_PER_SECOND: float = 200.0

var current_displayed_level: int = 1
var target_level: int = 1
var target_progress_ratio: float = 0

@onready var level_up_particles: GPUParticles2D = $LevelUpParticles


func _process(delta: float) -> void:
	var is_displayed_level_target: bool = target_level == current_displayed_level
	if is_displayed_level_target and target_progress_ratio == value / max_value:
		return
	
	var value_increasing_towards: float = target_progress_ratio * max_value
	if is_displayed_level_target == false:
		value_increasing_towards = max_value
	
	value = minf(value + VALUE_UPDATE_PER_SECOND * delta, value_increasing_towards)
	
	if value >= max_value and is_displayed_level_target == false:
		value = 0.0
		current_displayed_level += 1
		level_up_particles.emitting = true


func update(level: int, remainder_ratio: float, animate: bool = true) -> void:
	target_level = level
	target_progress_ratio = remainder_ratio
	
	if animate == false:
		current_displayed_level = target_level
		value = max_value * remainder_ratio
