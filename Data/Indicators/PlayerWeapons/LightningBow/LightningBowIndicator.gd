extends Node2D


func _ready() -> void:
	var rand_x_offset: float = randf_range(-50, 50)
	
	var transform_tween: Tween = get_tree().create_tween().set_parallel()
	transform_tween.tween_property($Sprite2D, "position", position, 0.2).from(position + Vector2(rand_x_offset, -120)).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	transform_tween.tween_property(self, "scale", scale, 0.3).from(Vector2.ZERO).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	var color_tween: Tween = get_tree().create_tween()
	color_tween.tween_property(self, "modulate:a", 0.9, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(self, "modulate:a", 0.6, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(self, "modulate:a", 0.9, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(self, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	await color_tween.finished
	
	queue_free()
