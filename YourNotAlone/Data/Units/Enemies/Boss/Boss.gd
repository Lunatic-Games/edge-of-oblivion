extends "res://Data/Units/Enemies/Enemy.gd"

export (Resource) var boss_data

func _ready():
	max_hp_override = boss_data.health
	move_precedence = 3.0
	._ready()
	GameManager.setup_boss(boss_data)

func choose_moveset():
	if move_sets.size() > 0:
		chosen_move = move_sets[0]
		chosen_move.indicate(currentTile)

func update_health_bar():
	GameManager.boss_health_bar.value = float(hp)/float(max_hp) * 100
	tween.interpolate_property(GameManager.boss_health_bar, "value", GameManager.boss_health_bar.value, float(hp)/float(max_hp) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	.update_health_bar()

func die():
	GameManager.boss_defeated()
	.die()
