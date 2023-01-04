extends "res://Item.gd"

# Tiers
# 1 - Shoot range 1 up, attacks chain 1 for 1 damage
# 2 - Attack chains 2
# 3 - Attack chains 4

var itemDamage = 1
var chains = 1
onready var remaining_chains = chains

func _ready():
	maxTurnTimer = 7
	turnTimer = maxTurnTimer
	updateShaderParam()

func triggerTimer():
	turnTimer -= 1
	updateShaderParam()
	
	if turnTimer <= 0:
		activateItem()

func activateItem():
	performAttack()
	turnTimer = maxTurnTimer
	updateShaderParam()

func performAttack():
	# Get the tile two tiles up
	var targetTile
	
	var oneTileUp = user.currentTile.topTile
	if !oneTileUp:
		return
	
	var twoTilesUp = oneTileUp.topTile
	if twoTilesUp:
		targetTile = twoTilesUp
	else:
		targetTile = oneTileUp
	
	attack(targetTile)
		
	$AnimationPlayer.play("Shake")

func attack(tile):
	spawnLightningParticle(tile)
	
	if tile.occupied && tile.occupied.isEnemy():
		tile.occupied.takeDamage(itemDamage)
	
	if remaining_chains > 0:
		var newTarget = tile.getRandomEnemyOccupiedAdjacentTile()
		remaining_chains -= 1
		if newTarget:
			attack(newTarget)
	
	if remaining_chains <= 0:
		remaining_chains = chains

func upgradeTier() -> bool:
	currentTier += 1
	
	if currentTier == 2:
		chains = 2
	
	if currentTier == 3:
		chains = 4
	
	if currentTier >= maxTier:
		return true
	
	return false
