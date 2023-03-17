extends "res://Item/Item.gd"

var damage_amount: int = 1
var max_blast_amount: int = 2
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
	charges = maxTurnTimer - turnTimer
	var chance_to_activate: float = float(maxTurnTimer - turnTimer) / maxTurnTimer
	var roll = randf()
	if roll < chance_to_activate:
		clear_timer_activate()
		return true
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
	var scan_res: ItemUtil.ScanResult = ItemUtil.scan_in_direction(user.currentTile, user.last_direction_moved, charges)
	var tiles: Array = scan_res.tiles
	spawn_fire_particles(tiles)
	attack(tiles)
	if not max_blast and currentTier >= 3:
		turnTimer -= 1
		update_cool_down_bar()
	max_blast = false
	charges = 0
	$AnimationPlayer.play("Shake")

func attack(tiles: Array) -> void:
	for t in tiles:
		var occupant: Occupant = t.occupied
		if occupant:
			if occupant.damageable:
				#occupant.takeDamage(damage_amount)
				if max_blast:
					occupant.takeDamage(max_blast_amount)
				else:
					occupant.takeDamage(damage_amount)

func spawn_fire_particles(tiles: Array) -> void:
	for t in tiles:
		var pos: Vector2 = t.global_position
		var particle: Node = fire_particle_scene.instance()
		particle.global_position = pos
		GameManager.gameboard.add_child(particle)
	
