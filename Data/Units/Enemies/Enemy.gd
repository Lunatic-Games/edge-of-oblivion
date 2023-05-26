class_name Enemy
extends Unit

signal update_triggered

@export var popup_info_text: String
@export var popup_flavor_text: String
@export var target_scene: PackedScene = preload("res://Data/Indicators/Indicator.tscn")
@export_range(0, 999, 1, "or_greater") var xp: int = 1
@export_range(0, 999, 1, "or_greater") var max_rounds_until_ready: int  = 2
@export_range(0, 999, 1, "or_greater") var damage: int = 1
@export_range(-1, 999, 1, "or_greater") var max_hp_override: int = 3

var chosen_move: Move

@onready var rounds_until_ready = max_rounds_until_ready
@onready var attack_bar = $AttackBar


func _ready() -> void:
	max_hp = max_hp_override
	pushable = true
	damageable = true
	update_attack_bar()
	appear_unready()
	super._ready()


func update() -> void:
	update_triggered.emit()
	GlobalLogicTreeSignals.entity_update_triggered.emit(self)


func appear_ready() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite.material, "shader_parameter/modulate:a", 1.0, 0.2)


func appear_unready() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite.material, "shader_parameter/modulate:a", 0.4, 0.2)


func update_attack_bar() -> void:
	var target_value: float = 100.0 * (1.0 - float(rounds_until_ready) / float(max_rounds_until_ready))
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(attack_bar, "value", target_value, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func is_enemy() -> bool:
	return true


func can_attack_player() -> bool:
	for tile in current_tile.get_adjacent_occupied_tiles():
		if tile.occupant == GameManager.player:
			return true
	
	return false


func die() -> void:
	GameManager.player.gain_experience(xp)
	GameManager.remove_enemy(self)
	super.die()
