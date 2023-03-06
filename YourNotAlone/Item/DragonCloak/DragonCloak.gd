extends "res://Item/Item.gd"


var damage_amount: int = 1
var range_radius: int = 1

onready var fire_particle_scene = preload("res://Data/Particles/FireParticles.tscn")
# Tiered cooldown: 
#	1: 6
#	2: 5
#	3: 4

func upgradeTier() -> bool:
	var ret: bool = .upgradeTier()
	match currentTier:
		2:
			self.maxTurnTimer = 5
		3:
			range_radius = 2
	return ret

func activateItem() -> void:
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack() -> void:
	#Scan all applicable tiles for valid targets, append each into targets
	var targets: Array = []
	var current_tile: Tile = user.currentTile
	# Navigate left
	var left_distance: int = 0
	var up_distance: int = 0
	#var _relative_x: int = 0
	#var _relative_y: int = 0
	for _i in range(0, range_radius):
		var next_tile = current_tile.leftTile
		if next_tile:
			current_tile = next_tile
			#_relative_x -= 1  # DEBUGGING
			left_distance += 1
		else:
			break
	# Navigate up
	for _i in range(0, range_radius):
		var next_tile = current_tile.topTile
		if next_tile:
			current_tile = next_tile
			#_relative_y -= 1  # DEBUGGING
			up_distance += 1
		else:
			break
	# Begin scanning by row
	for _i in range(-up_distance, range_radius + 1):
		var row_width: int = 0
		for _j in range(-left_distance,range_radius + 1):
			if not current_tile:
				continue
			#Check occupant
			var occupant: Occupant = current_tile.occupied
			spawn_fire_particle(current_tile.global_position)
			if occupant:
				if occupant.damageable and occupant != user:
					targets.append(occupant)
			#Move to next tile
			var next_tile: Tile = current_tile.rightTile
			if next_tile:
				current_tile = next_tile
				#_relative_x += 1  # DEBUGGING
				row_width += 1
			else:
				break
		#Slide to begining of row
		for _j in range(0, row_width):
			var next_tile: Tile = current_tile.leftTile
			if next_tile:
				current_tile = next_tile
				#_relative_x -= 1  # DEBUGGING
			else:
				break
		var next_tile: Tile = current_tile.bottomTile
		if next_tile:
			current_tile = next_tile
			#_relative_y += 1  # DEBUGGING
		else:
			break
	attack(targets)
	$AnimationPlayer.play("Shake")

func attack(targets: Array) -> void:
	# Iterate through array and deal damage to each target
	for target in targets:
		target.takeDamage(damage_amount)

func spawn_fire_particle(pos: Vector2) -> void:
	var particle = fire_particle_scene.instance()
	particle.global_position = pos
	GameManager.gameboard.add_child(particle)
