extends "res://Items/Item.gd"


func activate_item():
	performAttack()
	await get_tree().process_frame


func performAttack():
	var left_tile = user.current_tile.left_tile
	var right_tile = user.current_tile.right_tile
	
	if(left_tile):
		attack(left_tile)
	
	if (currentTier >= 2 && right_tile):
		attack(right_tile)
	
	$AnimationPlayer.play("Shake")


func attack(tile):
	spawn_slash_particle(tile.global_position)
	if tile.occupied && tile.occupied.is_enemy():
		tile.occupied.take_damage(item_damage)


func upgrade_tier() -> bool:
	currentTier += 1
	
	if currentTier == 2:
		maxTurnTimer = 4
		
	
	if currentTier == 3:
		item_damage = 4
	
	if currentTier >= maxTier:
		return true
	
	return false
