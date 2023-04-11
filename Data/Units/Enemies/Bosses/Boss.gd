extends "res://Data/Units/Enemies/Enemy.gd"

@export var boss_data: Resource


func _ready() -> void:
	max_hp_override = boss_data.health
	move_precedence = 3.0
	super._ready()
	GameManager.setup_boss(boss_data)


func choose_moveset() -> void:
	if move_sets.size() > 0:
		chosen_move = move_sets[0]
		chosen_move.indicate(current_tile)


func update_health_bar() -> void:
	var target_value: float = float(hp) / float(max_hp) * 100.0
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(GameManager.boss_health_bar, "value", target_value, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	super.update_health_bar()


func die() -> void:
	GameManager.boss_has_been_defeated()
	super.die()
