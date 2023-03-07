extends "res://Item/Item.gd"


var damage_amount: int = 1
var range_radius: int = 1

onready var fire_particle_scene = preload("res://Data/Particles/FireParticles.tscn")
# Tiers: 
#	1: 6 round cooldown, 1 tile radius
#	2: 5 round cooldown, 1 tile radius
#	3: 5 round cooldown, 2 tile radius

class ScanResult:
	var tiles: Array
	var occupants: Array
	func _init(passed_tiles: Array, passed_occupants: Array) -> void:
		tiles = passed_tiles
		occupants = passed_occupants

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
	var scan_res: ScanResult = scan_tile_radius(user.currentTile, range_radius)
	spawn_fire_particles(scan_res.tiles)
	attack(scan_res.occupants)
	$AnimationPlayer.play("Shake")

func scan_tile_radius(center_tile: Tile, radius: int) -> ScanResult:
	var tiles: Array = []
	var occupants: Array = []
	#Scan all applicable tiles for valid targets, append each into targets array
	var current_tile: Tile = center_tile
	# Navigate left
	var left_distance: int = 0
	var up_distance: int = 0
	for _i in range(0, radius):
		var next_tile: Tile = current_tile.leftTile
		if next_tile:
			current_tile = next_tile
			left_distance += 1
		else:
			break
	# Navigate up
	for _i in range(0, radius):
		var next_tile: Tile = current_tile.topTile
		if next_tile:
			current_tile = next_tile
			up_distance += 1
		else:
			break
	# Begin scanning by row
	for _i in range(-up_distance, radius + 1):
		var row_width: int = 0
		for _j in range(-left_distance, radius + 1):
			if not current_tile:
				continue
			tiles.append(current_tile)
			#Check occupant
			var occupant: Occupant = current_tile.occupied
			if occupant:
				occupants.append(occupant)
			#Move to next tile
			var next_tile: Tile = current_tile.rightTile
			if next_tile:
				current_tile = next_tile
				row_width += 1
			else:
				break
		#Slide to begining of row
		for _j in range(0, row_width):
			var next_tile: Tile = current_tile.leftTile
			if next_tile:
				current_tile = next_tile
			else:
				break
		var next_tile: Tile = current_tile.bottomTile
		if next_tile:
			current_tile = next_tile
		else:
			break
	return ScanResult.new(tiles,occupants)

func attack(targets: Array) -> void:
	for target in targets:
		if target.damageable and target != user:
			target.takeDamage(damage_amount)



func spawn_fire_particles(tiles: Array) -> void:
	for t in tiles:
		var pos: Vector2 = t.global_position
		var particle: Node = fire_particle_scene.instance()
		particle.global_position = pos
		GameManager.gameboard.add_child(particle)
