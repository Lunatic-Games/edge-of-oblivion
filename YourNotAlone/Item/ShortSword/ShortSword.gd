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
	
	if(leftTile):
		attack(leftTile)
	
	if (currentTier >= 2 && rightTile):
		attack(rightTile)
	
	$AnimationPlayer.play("Shake")

func attack(tile):
	spawnSlashParticle(tile)
	if tile.occupied && tile.occupied.isEnemy():
		tile.occupied.takeDamage(item_damage)
