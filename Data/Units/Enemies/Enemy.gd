extends "res://Data/Units/Unit.gd"

@export var target_scene: PackedScene = preload("res://Data/Indicators/Indicator.tscn")
@export_range(0, 999, 1, "or_greater") var xp: int = 1
@export_range(0, 999, 1, "or_greater") var max_rounds_until_ready: int  = 2
@export_range(0, 999, 1, "or_greater") var damage: int = 1
@export_range(-1, 999, 1, "or_greater") var max_hp_override: int = 3

var chosen_move

@onready var rounds_until_ready = max_rounds_until_ready
@onready var attack_bar = $AttackBar
@onready var move_sets = $MoveSets.get_children()


func _ready():
	max_hp = max_hp_override
	pushable = true
	damageable = true
	update_attack_bar()
	appear_unready()
	super._ready()


func activate():
	if rounds_until_ready <= 0:
		chosen_move.trigger(current_tile)
		rounds_until_ready = max_rounds_until_ready
		update_attack_bar()
		appear_unready()
	else:
		rounds_until_ready -= 1
		update_attack_bar()
		
		if rounds_until_ready <= 0:
			choose_moveset()
			appear_ready()


func choose_moveset():
	pass


func appear_ready():
	var goal_sprite = sprite.self_modulate
	goal_sprite.a = 1.0
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "self_modulate", goal_sprite, 0.2)


func appear_unready():
	var goal_sprite = sprite.self_modulate
	goal_sprite.a = 0.4
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "self_modulate", goal_sprite, 0.2)


func update_attack_bar():
	var target_value = 100.0 * (1.0 - float(rounds_until_ready) / float(max_rounds_until_ready))
	
	var tween = get_tree().create_tween()
	tween.tween_property(attack_bar, "value", target_value, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func is_enemy():
	return true


func can_attack_player():
	for tile in current_tile.get_adjacent_occupied_tiles():
		if tile.occupied == GameManager.player:
			return true
	
	return false


func die():
	GameManager.player.gain_experience(xp)
	GameManager.remove_enemy(self)
	super.die()
