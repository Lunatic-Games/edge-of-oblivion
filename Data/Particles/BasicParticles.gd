extends GPUParticles2D

func _ready() -> void:
	z_index = 2
	emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()
