extends "res://occupant.gd"

export (PackedScene) var targetScene = preload("res://Target.tscn")

var currentTile
var targetTiles = []
var maxHp = 3
var xp = 1
var maxRoundsUntilReady = 2
var damage = 1

onready var hp = maxHp
onready var roundsUntilReady = maxRoundsUntilReady
onready var playerNode = get_tree().get_nodes_in_group("player")[0]
onready var animation_player = $AnimationPlayer
onready var attack_bar = $AttackBar
onready var health_bar = $HealthBar
onready var tween = $Tween
onready var attack_ready_particle = $AttackReadyParticle

func _ready():
	$Sprite.material = $Sprite.material.duplicate()
	update_attack_bar()
	targetTiles = [currentTile.topTile, currentTile.bottomTile, currentTile.leftTile, currentTile.rightTile]

func setup():
	animation_player.play("spawn")
	yield(animation_player, "animation_finished")

func isEnemy():
	return true

func activate():
	if roundsUntilReady <= 0:
		# Make the goblins attack the player if adjacent
		if canAttackPlayer():
			playerNode.takeDamage(damage)
			
		roundsUntilReady = maxRoundsUntilReady
		update_attack_bar()
		#attack_ready_particle.one_shot = true
		animation_player.play("attack_not_ready")
	else:
		roundsUntilReady -= 1
		update_attack_bar()
		
		if roundsUntilReady <= 0:
			spawnTargets()
			animation_player.play("attack_ready")
			#attack_ready_particle.one_shot = false
			#attack_ready_particle.emitting = true
	

func takeDamage(damageTaken):
	hp -= damageTaken
	update_health_bar()
	
	if hp <= 0:
		die()

func update_health_bar():
	health_bar.value = float(hp)/float(maxHp) * 100
	tween.interpolate_property(health_bar, "value", health_bar.value, float(hp)/float(maxHp) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

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

func die():
	playerNode.gainExperience(xp)
	TurnManager.removeEnemy(self)
	currentTile.occupied = null
	queue_free()

func is_alive():
	if hp > 0:
		return true
	return false

func moveToTile(tile):
	if tile.occupied && tile.occupied.occupantType == tile.occupied.occupantTypes.blocking:
		return
	
	if tile.occupied && tile.occupied.occupantType == tile.occupied.occupantTypes.collectable:
		#tile.occupied.collect()
		pass
	
	GameManager.unoccupyTile(currentTile)
	GameManager.occupyTile(tile, self)
	currentTile = tile
	position = tile.position
