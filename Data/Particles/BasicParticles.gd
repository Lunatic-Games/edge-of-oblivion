extends GPUParticles2D

var extra_time_for_particles_to_fade: int = 10

func _ready() -> void:
	z_index = 2
	emitting = true
	await get_tree().create_timer(lifetime + extra_time_for_particles_to_fade).timeout
	queue_free()
