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

func _ready():
	$Sprite.material = $Sprite.material.duplicate()
	updateShaderParam()
	targetTiles = [currentTile.topTile, currentTile.bottomTile, currentTile.leftTile, currentTile.rightTile]

func isEnemy():
	return true

func activate():
	if roundsUntilReady <= 0:
		# Make the goblins attack the player if adjacent
		if canAttackPlayer():
			playerNode.takeDamage(damage)
			
		roundsUntilReady = maxRoundsUntilReady
		updateShaderParam()
	else:
		roundsUntilReady -= 1
		updateShaderParam()
		
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

func updateShaderParam():
	$Sprite.material.set_shader_param("progress", float(roundsUntilReady)/float(maxRoundsUntilReady))

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
