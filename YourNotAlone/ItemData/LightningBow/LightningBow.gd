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
	update_cool_down_bar()

func triggerTimer():
	turnTimer -= 1
	update_cool_down_bar()
	
	if turnTimer == 1:
		return true
	
	if turnTimer <= 0:
		yield(activateItem(), "completed")
	
	return false

func activateItem():
	yield(performAttack(), "completed")
	turnTimer = maxTurnTimer
	update_cool_down_bar()
	yield(get_tree(), "idle_frame")

func performAttack():
	# Get the tile two tiles up
	var targetTile
	
	var oneTileUp = user.currentTile.topTile
	if !oneTileUp:
		yield(get_tree(), "idle_frame")
		return
	
	var twoTilesUp = oneTileUp.topTile
	if twoTilesUp:
		targetTile = twoTilesUp
	else:
		targetTile = oneTileUp
	
	$AnimationPlayer.play("Shake")
	
	yield(attack(targetTile), "completed")


func attack(tile):
	spawnLightningParticle(tile)
	
	if tile.occupied && tile.occupied.isEnemy():
		tile.occupied.takeDamage(itemDamage)
	
	yield(get_tree().create_timer(0.4), "timeout")
	if remaining_chains > 0:
		var newTarget = tile.getRandomEnemyOccupiedAdjacentTile()
		remaining_chains -= 1
		if newTarget:
			yield(attack(newTarget), "completed")
	
	if remaining_chains <= 0:
		remaining_chains = chains
	
	yield(get_tree(), "idle_frame")

func upgradeTier() -> bool:
	currentTier += 1
	
	if currentTier == 2:
		chains = 2
		remaining_chains = 2
	
	if currentTier == 3:
		chains = 4
		remaining_chains = 2
	
	if currentTier >= maxTier:
		return true
	
	return false
