extends "res://Item/Item.gd"

#1
#Hit someone up, or down, for 1, then knock them back 1
#2
# If they hit another person, do damage to both of them again
#3
# knock back distance is maxed, and do more damage

var knockback: int = 1

func activateItem() -> void:
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack() -> void:
	var top_tile = user.currentTile.topTile
	var bottom_tile = user.currentTile.bottomTile
	
	if(top_tile && top_tile.occupied && top_tile.occupied.isEnemy()):
		attack(top_tile.occupied, "up")
	elif (bottom_tile && bottom_tile.occupied && bottom_tile.occupied.isEnemy()):
		attack(bottom_tile.occupied, "down")

func attack(occupant: Occupant, direction: String) -> void:
	spawnSlashParticle(occupant)
	occupant.takeDamage(item_damage)
	applyKnockBack(occupant, direction, knockback, 1)
	#TODO Move all the code below this into a "knockback_unit_damage_on_collide" function
	# Within the base item script so that it can be easily called from future items we create!

