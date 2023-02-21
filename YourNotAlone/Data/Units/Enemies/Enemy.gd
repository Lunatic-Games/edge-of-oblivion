extends "res://Data/Units/Unit.gd"

export (PackedScene) var targetScene = preload("res://Target.tscn")
var xp = 1
var maxRoundsUntilReady = 2
var damage = 1
var targetTiles = []
var chosen_move

onready var roundsUntilReady = maxRoundsUntilReady
onready var attack_bar = $AttackBar
onready var move_sets = $MoveSets.get_children()
onready var playerNode = get_tree().get_nodes_in_group("player")[0]

func _ready():
	update_attack_bar()
	targetTiles = [currentTile.topTile, currentTile.bottomTile, currentTile.leftTile, currentTile.rightTile]

func activate():
	if roundsUntilReady <= 0:
		chosen_move.trigger(currentTile)
		roundsUntilReady = maxRoundsUntilReady
		update_attack_bar()
	else:
		roundsUntilReady -= 1
		update_attack_bar()
		
		if roundsUntilReady <= 0:
			choose_moveset()

func choose_moveset():
	if move_sets.size() > 0:
		chosen_move = move_sets[0]
		chosen_move.indicate(currentTile)

func update_attack_bar():
	tween.interpolate_property(attack_bar, "value", attack_bar.value, (1 - float(roundsUntilReady)/float(maxRoundsUntilReady)) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func spawnTargets():
	for tile in targetTiles:
		if !tile:
			continue
		var target = targetScene.instance()
		target.position = tile.position
		get_tree().root.add_child(target)

func isEnemy():
	return true

func canAttackPlayer():
	if currentTile.topTile && currentTile.topTile.occupied && currentTile.topTile.occupied == playerNode:
		return true
	if currentTile.bottomTile && currentTile.bottomTile.occupied && currentTile.bottomTile.occupied == playerNode:
		return true
	if currentTile.rightTile && currentTile.rightTile.occupied && currentTile.rightTile.occupied == playerNode:
		return true
	if currentTile.leftTile && currentTile.leftTile.occupied && currentTile.leftTile.occupied == playerNode:
		return true
	return false

func die():
	playerNode.gainExperience(xp)
	TurnManager.removeEnemy(self)
	.die()
