extends "res://Item.gd"

# Tiers
# 1 - Attack left space
# 2 - Attack right space also
# 3 - Attacks two turns in a row

var itemDamage = 1

func _ready():
	maxTurnTimer = 3
	turnTimer = maxTurnTimer
	update_cool_down_bar()

func triggerTimer():
	turnTimer -= 1
	update_cool_down_bar()
	
	if currentTier == 3 && turnTimer == maxTurnTimer-1:
		performAttack()
	
	if turnTimer == 1:
		return true
	
	if turnTimer <= 0:
		activateItem()
	
	return false

func activateItem():
	performAttack()
	turnTimer = maxTurnTimer
	update_cool_down_bar()

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
