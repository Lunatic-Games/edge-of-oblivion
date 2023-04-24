@icon("res://Assets/art/logic-tree/effects/check-mark.png")
class_name LT_SetEnemiesReadyAppearance
extends LogicTreeEffect


@export var enemies: LT_EntityArrayVariable
@export var appear_ready: bool = true


func _ready() -> void:
	assert(enemies != null, "Enemies not set for '" + name + "'")


func perform_behavior() -> void:
	for entity in enemies.value:
		var enemy: Enemy = entity as Enemy
		assert(enemy != null, "Non-enemy in enemies array for '" + name + "'")
		if appear_ready:
			enemy.appear_ready()
		else:
			enemy.appear_unready()
