extends Node2D

onready var tween = $Tween

func _ready():
	var rand_x_offset = rand_range(-50, 50)
	
	tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0.9), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0.9), Color(1,1,1,0.6), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.2)
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0.6), Color(1,1,1,0.9), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0.9), Color(1,1,1,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.4)
	tween.interpolate_property(self, "global_position", global_position + Vector2(rand_x_offset, -120), global_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(self, "scale", Vector2(0,0), scale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
