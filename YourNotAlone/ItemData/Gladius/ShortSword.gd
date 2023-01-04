extends "res://Item.gd"

# Tiers
# 1 - Attack left space
# 2 - Attack right space also
# 3 - Attacks two turns in a row

var itemDamage = 1

func _ready():
	maxTurnTimer = 3
	turnTimer = maxTurnTimer
	updateShaderParam()

func triggerTimer():
	turnTimer -= 1
	updateShaderParam()
	
	if currentTier == 3 && turnTimer == maxTurnTimer-1:
		performAttack()
	
	if turnTimer <= 0:
		activateItem()

func activateItem():
	performAttack()
	turnTimer = maxTurnTimer
	updateShaderParam()

func performAttack():
	var leftTile = user.currentTile.leftTile
	var rightTile = user.currentTile.rightTile
	
	if(leftTile && leftTile.occupied && leftTile.occupied.isEnemy()):
		attack(leftTile.occupied)
	
	if (currentTier >= 2 && rightTile && rightTile.occupied && rightTile.occupied.isEnemy()):
		attack(rightTile.occupied)
	
	$AnimationPlayer.play("Shake")

func attack(occupant):
	spawnSlashParticle(occupant)
	occupant.takeDamage(itemDamage)
