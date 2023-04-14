extends "res://Items/Item.gd"


func activate_item():
	performAttack()
	await get_tree().process_frame


func performAttack():
	var left_tile = user.current_tile.left_tile
	var right_tile = user.current_tile.right_tile
	
	if(left_tile):
		attack(left_tile)
	
	if (current_tier >= 2 && right_tile):
		attack(right_tile)
	
	$AnimationPlayer.play("Shake")


func attack(tile):
	spawn_slash_particle(tile.global_position)
	if tile.occupant && tile.occupant.is_enemy():
		tile.occupant.take_damage(item_damage)


func upgrade_tier() -> bool:
	current_tier += 1
	
	if current_tier == 2:
		maxTurnTimer = 4
		
	
	if current_tier == 3:
		item_damage = 4
	
	if current_tier >= maxTier:
		return true
	
	return false
