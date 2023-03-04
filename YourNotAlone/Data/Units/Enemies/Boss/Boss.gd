extends "res://Data/Units/Enemies/Enemy.gd"

export (Resource) var boss_data

func _ready():
	maxHp = boss_data.health
	._ready()
	GameManager.setup_boss(boss_data)

func choose_moveset():
	if move_sets.size() > 0:
		chosen_move = move_sets[0]
		chosen_move.indicate(currentTile)

func update_health_bar():
	GameManager.boss_health_bar.value = float(hp)/float(maxHp) * 100
	tween.interpolate_property(GameManager.boss_health_bar, "value", GameManager.boss_health_bar.value, float(hp)/float(maxHp) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	.update_health_bar()

func die():
	GameManager.boss_defeated()
	.die()