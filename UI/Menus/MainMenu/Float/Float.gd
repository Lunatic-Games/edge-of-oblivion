extends TextureRect


@export var float_distance: float = 5
@export_range(0.1, 10.0, 0.1, "or_greater") var loop_length_seconds: float = 1.0
@export_range(0.0, 10.0, 0.1, "or_greater") var offset_seconds: float = 0.0


func _ready() -> void:
	var tween: Tween = create_tween()
	
	tween.tween_property(self, "position:y", float_distance, 
		loop_length_seconds / 2.0).as_relative().set_trans(
		Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		
	tween.tween_property(self, "position:y", -float_distance, 
		loop_length_seconds / 2.0).as_relative().set_trans(
		Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.set_loops()
	tween.custom_step(offset_seconds)
