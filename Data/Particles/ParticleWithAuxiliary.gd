extends GPUParticles2D

# This particle type is for situations where a particle could have an additional effect (eg. crit)

var aux: bool = false

func activate() -> void:
	emitting = true
	if aux:
		self.get_child(0).emitting = true

func _process(_delta: float) -> void:
	if emitting == false:
		queue_free()
