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

func activateItem() -> void:
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack() -> void:
	var top_tile = user.currentTile.topTile
	var bottom_tile = user.currentTile.bottomTile
	
	if(top_tile && top_tile.occupied):
		attack(top_tile, "up")
	elif (bottom_tile && bottom_tile.occupied):
		attack(bottom_tile, "down", true)
	elif (top_tile):
		attack(top_tile, "up")
	elif (bottom_tile):
		attack(bottom_tile, "down", true)

func attack(tile: Tile, direction: String, should_flip: bool = false) -> void:
	var occupant = tile.occupied
	spawn_hammer_indicator(tile.global_position, should_flip)
	if occupant && occupant.isEnemy():
		applyKnockBack(occupant, direction, tiered_knockback[currentTier], tiered_kb_damage[currentTier])
		occupant.takeDamage(tiered_damage[currentTier])
