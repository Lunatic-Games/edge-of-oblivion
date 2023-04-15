extends "res://Items/Item.gd"


func activate_item() -> void:
	perform_attack()
	await get_tree().process_frame


func perform_attack() -> void:
	var left_tile: Tile = user.current_tile.left_tile
	var right_tile: Tile = user.current_tile.right_tile
	
	if(left_tile):
		attack(left_tile)
	
	if (current_tier >= 2 && right_tile):
		attack(right_tile)
	
	$AnimationPlayer.play("Shake")


func attack(tile: Tile) -> void:
	spawn_slash_particle(tile.global_position)
	if tile.occupant && tile.occupant.is_enemy():
		tile.occupant.take_damage(item_damage)


func upgrade_tier() -> bool:
	current_tier += 1
	
	if current_tier == 2:
		max_turn_timer = 4
		
	
	if current_tier == 3:
		item_damage = 4
	
	if current_tier >= max_tier:
		return true
	
	return false
