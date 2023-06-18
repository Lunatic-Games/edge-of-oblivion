extends Node2D


const RANDOM_X_OFFSET_MAX_DISTANCE: float = 50
const START_Y_OFFSET: float = -120

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	var x_offset: float = randf_range(-RANDOM_X_OFFSET_MAX_DISTANCE,
		RANDOM_X_OFFSET_MAX_DISTANCE)
	var start_position: Vector2 = position + Vector2(x_offset, START_Y_OFFSET)
	
	var transform_tween: Tween = create_tween().set_parallel()
	
	transform_tween.tween_property(sprite, "position", position, 0.2).from(
		start_position).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	transform_tween.tween_property(self, "scale", scale, 0.3).from(Vector2.ZERO).set_trans(
		Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	var color_tween: Tween = create_tween()
	tween_alpha(color_tween, 0.9, 0.2)
	tween_alpha(color_tween, 0.6, 0.1)
	tween_alpha(color_tween, 0.9, 0.1)
	tween_alpha(color_tween, 0.0, 0.3)
	
	await color_tween.finished
	
	queue_free()


func tween_alpha(tween: Tween, alpha_value: float, time_length_seconds: float):
	tween.tween_property(self, "modulate:a", alpha_value, time_length_seconds).set_trans(
		Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
