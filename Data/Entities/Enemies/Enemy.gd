class_name Enemy
extends Entity


@onready var attack_bar: AttackBar = $AttackBar


func setup(p_data: EntityData) -> void:
	super.setup(p_data)
	if health != null:
		health.died.connect(_on_died)


func appear_ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate:a", 1.0, 0.2)


func appear_unready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate:a", 0.4, 0.2)


func _on_died():
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	var enemy_data: EnemyData = data as EnemyData
	player.levelling.gain_xp(enemy_data.xp_value)
	
	GlobalSignals.enemy_killed.emit(self)
	if enemy_data.boss_data != null:
		GlobalSignals.boss_defeated.emit(self)
