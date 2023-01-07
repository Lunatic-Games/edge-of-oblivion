extends "res://occupant.gd"

export (PackedScene) var targetScene = preload("res://Target.tscn")

var currentTile
var targetTiles = []
var maxHp = 1
var xp = 1
var maxRoundsUntilReady = 2
var damage = 1

onready var hp = maxHp
onready var roundsUntilReady = maxRoundsUntilReady
onready var playerNode = get_tree().get_nodes_in_group("player")[0]
onready var animation_player = $AnimationPlayer
onready var attack_bar = $AttackBar
onready var tween = $Tween

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
	else:
		roundsUntilReady -= 1
		update_attack_bar()
		
		if roundsUntilReady <= 0:
			spawnTargets()
	

func takeDamage(damageTaken):
	hp -= damageTaken
	
	if hp <= 0:
		die()

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
