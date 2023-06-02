class_name Boss
extends Enemy


@export_placeholder("BOSS NAME") var display_name: String
@export var sound_track: AudioStream


func _ready() -> void:
	super._ready()
	GlobalSignals.boss_spawned.emit(self)


func update_health_bar() -> void:
	var target_value: float = float(self.hp) / float(self.max_hp) * 100.0

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(GameManager.boss_health_bar, "value", target_value, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	super.update_health_bar()


func die() -> void:
	GlobalSignals.boss_defeated.emit(self)
	super.die()
