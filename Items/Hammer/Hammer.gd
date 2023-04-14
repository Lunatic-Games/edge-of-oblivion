extends "res://Items/Item.gd"

#1
#Hit someone up, or down, for 1, then knock them back 1
#2
# If they hit another person, do damage to both of them again
#3
# knock back distance is maxed, and do more damage

var tiered_knockback: Dictionary = {1:1, 2:1, 3:2}
var tiered_damage: Dictionary = {1:1, 2:1, 3:2}
var tiered_kb_damage: Dictionary = {1:0, 2:1, 3:1}

func activate_item() -> void:
	perform_attack()
	await get_tree().process_frame


func perform_attack() -> void:
	var top_tile: Tile = user.current_tile.top_tile
	var bottom_tile: Tile = user.current_tile.bottom_tile
	
	if(top_tile && top_tile.occupant):
		attack(top_tile, "up")
	elif (bottom_tile && bottom_tile.occupant):
		attack(bottom_tile, "down", true)
	elif (top_tile):
		attack(top_tile, "up")
	elif (bottom_tile):
		attack(bottom_tile, "down", true)


func attack(tile: Tile, direction: String, should_flip: bool = false) -> void:
	var occupant = tile.occupant
	spawn_hammer_indicator(tile.global_position, should_flip)
	if occupant && occupant.is_enemy():
		apply_knockback(occupant, direction, tiered_knockback[current_tier], tiered_kb_damage[current_tier])
		occupant.take_damage(tiered_damage[current_tier])

