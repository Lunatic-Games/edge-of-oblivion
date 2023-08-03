class_name Enemy
extends Entity


@onready var attack_bar: AttackBar = $AttackBar


func appear_ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate:a", 1.0, 0.2)


func appear_unready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate:a", 0.4, 0.2)
