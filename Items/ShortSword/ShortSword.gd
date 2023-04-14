extends "res://Items/Item.gd"

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
	spawnSlashParticle(tile.global_position)
	if tile.occupied && tile.occupied.isEnemy():
		tile.occupied.takeDamage(item_damage)

func upgradeTier() -> bool:
	currentTier += 1
	
	if currentTier == 2:
		maxTurnTimer = 4
		
	
	if currentTier == 3:
		item_damage = 4
	
	if currentTier >= maxTier:
		return true
	
	return false
