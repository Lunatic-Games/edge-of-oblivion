extends "res://Item/Item.gd"

var damage_amount: int = 1
var max_blast: bool = false
var charges: int = 0

onready var fire_particle_scene = preload("res://Data/Particles/FireParticles.tscn")
# Tiers: 
#	1: 3 max charges
#	2: 4 max charges
#	3: 5 max charges

func _ready():
	activation_style = ACTIVATION_STYLES.on_charge
	._ready()

# Returns true if item activated
func activate_on_charge() -> bool:
	# Roll chance
	if turnTimer == 1:
		max_blast = true
	var chance_to_activate: float = float(maxTurnTimer - turnTimer) / maxTurnTimer
	var roll = randf()
	#print(chance_to_activate, roll)
	if roll < chance_to_activate:
		#print("passed roll")
		charges = maxTurnTimer - turnTimer
		clear_timer_activate()
		return true
	#print("Failed roll")
	return false
	
func upgradeTier() -> bool:
	var ret: bool = .upgradeTier()
	match currentTier:
		2:
			maxTurnTimer = 4
		3:
			maxTurnTimer = 5
	update_cool_down_bar()
	return ret

func activateItem() -> void:
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack() -> void:
	var tiles: Array = gather_tiles()
	spawn_fire_particles(tiles)
	attack(tiles)
	max_blast = false
	charges = 0
	$AnimationPlayer.play("Shake")

func gather_tiles() -> Array:
	var tiles: Array = []
	var current_tile: Tile = user.currentTile
	if charges == 0:
		print("ERROR NO CHARGES")
	if not current_tile:
		return []
	match user.last_direction_moved:
		"up":
			for i in range(charges):
				current_tile = current_tile.topTile
				if current_tile:
					tiles.append(current_tile)
					if i > 0 and max_blast and currentTier >= 2:
						var side1: Tile = current_tile.leftTile
						var side2: Tile = current_tile.rightTile
						if side1:
							tiles.append(side1)
						if side2:
							tiles.append(side2)
				else:
					break
				if not current_tile.topTile:
					break
		"down":
			for i in range(charges):
				current_tile = current_tile.bottomTile
				if current_tile:
					tiles.append(current_tile)
					if i > 0 and max_blast and currentTier >= 2:
						var side1: Tile = current_tile.leftTile
						var side2: Tile = current_tile.rightTile
						if side1:
							tiles.append(side1)
						if side2:
							tiles.append(side2)
				else:
					break
				if not current_tile.bottomTile:
					break
		"left":
			for i in range(charges):
				current_tile = current_tile.leftTile
				if current_tile:
					tiles.append(current_tile)
					if i > 0 and max_blast and currentTier >= 2:
						var side1: Tile = current_tile.topTile
						var side2: Tile = current_tile.bottomTile
						if side1:
							tiles.append(side1)
						if side2:
							tiles.append(side2)
				else:
					break
				if not current_tile.leftTile:
					break
		"right":
			for i in range(charges):
				current_tile = current_tile.rightTile
				if current_tile:
					tiles.append(current_tile)
					if i > 0 and max_blast and currentTier >= 2:
						var side1: Tile = current_tile.topTile
						var side2: Tile = current_tile.bottomTile
						if side1:
							tiles.append(side1)
						if side2:
							tiles.append(side2)
				else:
					break
				if not current_tile.rightTile:
					break
	return tiles

func attack(tiles: Array) -> void:
	for t in tiles:
		var occupant: Occupant = t.occupied
		if occupant:
			if occupant.damageable:
				occupant.takeDamage(damage_amount)

func spawn_fire_particles(tiles: Array) -> void:
	for t in tiles:
		var pos: Vector2 = t.global_position
		var particle: Node = fire_particle_scene.instance()
		particle.global_position = pos
		GameManager.gameboard.add_child(particle)
	
