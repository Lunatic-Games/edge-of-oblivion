class_name Enemy
extends Unit


signal update_triggered

var data: EnemyData = null

@onready var attack_bar = $AttackBar


func _ready() -> void:
	pushable = true
	damageable = true
	appear_unready()
	play_spawn_animation()


func setup(enemy_data: EnemyData) -> void:
	data = enemy_data


func update() -> void:
	update_triggered.emit()
	GlobalLogicTreeSignals.entity_update_triggered.emit(self)


func appear_ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/modulate:a", 1.0, 0.2)


func appear_unready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/modulate:a", 0.4, 0.2)


func die() -> void:
	GlobalGameState.player.gain_experience(data.xp_value)
	GlobalSignals.enemy_killed.emit(self)
	if data.is_boss:
		GlobalSignals.boss_defeated.emit(self)
	super.die()
