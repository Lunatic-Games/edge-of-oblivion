extends "res://Item/Item.gd"

# Tiers
# 1 - Attack left space
# 2 - Attack right space also
# 3 - Attacks two turns in a row

func activateItem():
	performAttack()
	yield(get_tree(), "idle_frame")

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
	occupant.takeDamage(item_damage)
