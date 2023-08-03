class_name BossOverlay
extends CanvasLayer


const HEALTH_BAR_TWEEN_TIME: float = 0.2

var health_bar_tween: Tween

@onready var health_bar = $MarginContainer/Container/HealthBar
@onready var title = $MarginContainer/Container/Title


func _ready() -> void:
	GlobalSignals.boss_spawned.connect(_on_boss_spawned)


func _on_boss_spawned(boss: Enemy) -> void:
	title.text = "[shake]" + boss.data.enemy_name + "[/shake]"
	boss.health_changed.connect(_on_boss_health_changed.bind(boss))
	show()


func _on_boss_health_changed(boss: Enemy) -> void:
	if health_bar_tween:
		health_bar_tween.kill()
	
	var target_value: float = float(boss.hp) / float(boss.max_hp) * health_bar.max_value
	health_bar_tween = create_tween()
	health_bar_tween.tween_property(health_bar, "value", target_value, 
		HEALTH_BAR_TWEEN_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
