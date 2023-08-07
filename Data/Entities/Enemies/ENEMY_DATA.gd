class_name EnemyData
extends EntityData


@export var xp_value: int = 1
@export var boss_data: BossData


func is_boss():
	return boss_data != null
