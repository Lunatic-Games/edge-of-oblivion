class_name Enemy
extends Unit

signal update_triggered

@export var popup_info_text: String
@export var popup_flavor_text: String
@export_range(0, 999, 1, "or_greater") var xp: int = 1

@onready var attack_bar = $AttackBar


func _ready() -> void:
	pushable = true
	damageable = true
	appear_unready()
	play_spawn_animation()


func update() -> void:
	update_triggered.emit()
	GlobalLogicTreeSignals.entity_update_triggered.emit(self)


func appear_ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/modulate:a", 1.0, 0.2)


func appear_unready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/modulate:a", 0.4, 0.2)


func can_attack_player() -> bool:
	for tile in current_tile.get_adjacent_occupied_tiles():
		if tile.occupant == GameManager.player:
			return true
	
	return false


func die() -> void:
	GameManager.player.gain_experience(xp)
	super.die()
