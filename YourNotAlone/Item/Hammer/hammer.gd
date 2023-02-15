extends "res://Item/Item.gd"

#1
#Hit someone up, or down, for 1, then knock them back 1
#2
# If they hit another person, do damage to both of them again
#3
# knock back distance is maxed, and do more damage

var knockback = 2

func activateItem():
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack():
	var top_tile = user.currentTile.topTile
	var bottom_tile = user.currentTile.bottomTile
	
	if(top_tile && top_tile.occupied && top_tile.occupied.isEnemy()):
		attack(top_tile.occupied, "up")
	elif (bottom_tile && bottom_tile.occupied && bottom_tile.occupied.isEnemy()):
		attack(bottom_tile.occupied, "down")

func attack(occupant, direction):
	var new_tile = occupant.currentTile
	spawnSlashParticle(occupant)
	occupant.takeDamage(item_damage)
	
	#TODO Move all the code below this into a "knockback_unit_damage_on_collide" function
	# Within the base item script so that it can be easily called from future items we create!
	if occupant.is_alive():
		if direction == "up":
			for x in knockback:
				var tile_to_check = new_tile.topTile
				if tile_to_check and tile_to_check.occupied:
					# Then do damage to both the currrent enemy and the unit on this tile
					pass
				elif tile_to_check:
					new_tile = tile_to_check
		elif direction == "down":
			for x in knockback:
				var tile_to_check = new_tile.bottomTile
				if tile_to_check and tile_to_check.occupied:
					# Then do damage to both the currrent enemy and the unit on this tile
					pass
				elif tile_to_check:
					new_tile = tile_to_check
		
		occupant.moveToTile(new_tile)
