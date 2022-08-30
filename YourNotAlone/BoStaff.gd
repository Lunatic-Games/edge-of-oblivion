extends "res://Item.gd"

# Tiers
# 1 - Jump Attack
# 2 - Attack right space also
# 3 - Attacks two turns in a row

var itemDamage = 1

func _ready():
	maxTurnTimer = 5
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
	# Get the furthest tile in the direction we last moved, up to 2 spaces away.
	var directionTile = user.currentTile.getTileInDirection(MovementUtility.lastPlayerDirection)
	if directionTile == null:
		return
	
	var landingTile = directionTile.getTileInDirection(MovementUtility.lastPlayerDirection)
	if landingTile == null:
		landingTile = directionTile
	
	if landingTile.occupied && landingTile.occupied.isEnemy():
		attack(landingTile.occupied)
	
	var freeTileLocation = user.currentTile
	if !landingTile.occupied or landingTile.occupied.occupantType == landingTile.occupied.occupantTypes.consumable:
		user.moveToTile(landingTile, MovementUtility.lastPlayerDirection)
	
	else:
		if directionTile != landingTile && directionTile.occupied:
			directionTile.occupied.moveToTile(freeTileLocation)
			freeTileLocation = directionTile
		
		if landingTile.occupied:
			landingTile.occupied.moveToTile(freeTileLocation)
	
	$AnimationPlayer.play("Shake")

func attack(occupant):
	spawnSlashParticle(occupant)
	occupant.takeDamage(itemDamage)
