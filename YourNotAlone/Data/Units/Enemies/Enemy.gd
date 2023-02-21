extends "res://Data/Units/Unit.gd"

export (PackedScene) var targetScene = preload("res://Target.tscn")
var xp = 1
var maxRoundsUntilReady = 2
var damage = 1
var targetTiles = []

onready var roundsUntilReady = maxRoundsUntilReady
onready var attack_bar = $AttackBar

func _ready():
	update_attack_bar()
	targetTiles = [currentTile.topTile, currentTile.bottomTile, currentTile.leftTile, currentTile.rightTile]

func activate(): # ENEMY also please move into more functions, so we can easily build new enemies
	if roundsUntilReady <= 0:
		if canAttackPlayer():
			GameManager.player.takeDamage(damage)
			
		roundsUntilReady = maxRoundsUntilReady
		update_attack_bar()
		#animation_player.play("attack_not_ready")
	else:
		roundsUntilReady -= 1
		update_attack_bar()
		
		if roundsUntilReady <= 0:
			spawnTargets()
			#animation_player.play("attack_ready")

func update_attack_bar():
	tween.interpolate_property(attack_bar, "value", attack_bar.value, (1 - float(roundsUntilReady)/float(maxRoundsUntilReady)) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func spawnTargets():
	for tile in targetTiles:
		if !tile:
			continue
		var target = targetScene.instance()
		target.position = tile.position
		GameManager.gameboard.add_child(target)

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
