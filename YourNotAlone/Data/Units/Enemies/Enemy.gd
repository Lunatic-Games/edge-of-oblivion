extends "res://Data/Units/Unit.gd"

export (PackedScene) var targetScene = preload("res://Data/Indicators/Indicator.tscn")
var xp = 1
var maxRoundsUntilReady = 2
var damage = 1
var chosen_move

onready var roundsUntilReady = maxRoundsUntilReady
onready var attack_bar = $AttackBar
onready var move_sets = $MoveSets.get_children()

func _ready():
	pushable = true
	damageable = true
	update_attack_bar()
	appear_unready()
	._ready()

func activate():
	if roundsUntilReady <= 0:
		chosen_move.trigger(currentTile)
		roundsUntilReady = maxRoundsUntilReady
		update_attack_bar()
		appear_unready()
	else:
		roundsUntilReady -= 1
		update_attack_bar()
		
		if roundsUntilReady <= 0:
			choose_moveset()
			appear_ready()

func choose_moveset():
	pass

func appear_ready():
	var goal_sprite = sprite.self_modulate
	goal_sprite.a = 1.0
	tween.interpolate_property(sprite, "self_modulate", sprite.self_modulate, goal_sprite, 0.2)
	tween.start()

func appear_unready():
	var goal_sprite = sprite.self_modulate
	goal_sprite.a = 0.6
	tween.interpolate_property(sprite, "self_modulate", sprite.self_modulate, goal_sprite, 0.2)
	tween.start()

func update_attack_bar():
	tween.interpolate_property(attack_bar, "value", attack_bar.value, (1 - float(roundsUntilReady)/float(maxRoundsUntilReady)) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func isEnemy():
	return true

func canAttackPlayer():
	if currentTile.topTile && currentTile.topTile.occupied && currentTile.topTile.occupied == GameManager.player:
		return true
	if currentTile.bottomTile && currentTile.bottomTile.occupied && currentTile.bottomTile.occupied == GameManager.player:
		return true
	if currentTile.rightTile && currentTile.rightTile.occupied && currentTile.rightTile.occupied == GameManager.player:
		return true
	if currentTile.leftTile && currentTile.leftTile.occupied && currentTile.leftTile.occupied == GameManager.player:
		return true
	return false

func die():
	GameManager.player.gainExperience(xp)
	GameManager.removeEnemy(self)
	.die()
