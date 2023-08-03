class_name AttackBar
extends ProgressBar


@onready var animator: AnimationPlayer = $AnimationPlayer


func set_progress(ratio: float, flash_if_full: bool = true):
	var new_value: float = max_value * ratio
	var tween: Tween = create_tween()
	tween.tween_property(self, "value", new_value, 0.2)
	
	if new_value == max_value and flash_if_full:
		animator.play("flash")
	else:
		animator.play("RESET")
