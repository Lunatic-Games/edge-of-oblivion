extends GPUParticles2D

var longest_timer: float = 0.0

func _ready() -> void:
	z_index = 2
	for child in get_children():
		if child is GPUParticles2D:
			child.emitting = true
			if child.lifetime > longest_timer:
				longest_timer = child.lifetime
	
	await get_tree().create_timer(longest_timer).timeout
	queue_free()
