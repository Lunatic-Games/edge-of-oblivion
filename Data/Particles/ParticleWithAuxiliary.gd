extends Particles2D

# This particle type is for situations where a particle could have an additional effect (eg. crit)

var aux: bool = false

func activate():
	emitting = true
	if aux:
		self.get_child(0).emitting = true

func _process(delta):
	if emitting == false:
		queue_free()
