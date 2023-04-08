extends "res://Item/Item.gd"

var damage_amount: int = 1
var range_radius: int = 1

onready var fire_particle_scene = preload("res://Data/Particles/FireParticles.tscn")
# Tiers: 
#	1: 6 round cooldown, 1 tile radius
#	2: 5 round cooldown, 1 tile radius
#	3: 5 round cooldown, 2 tile radius



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
	var scan_res: ItemUtil.ScanResult = ItemUtil.scan_tile_radius(user.currentTile, range_radius)
	spawn_fire_particles(scan_res.tiles)
	attack(scan_res.occupants)
	$AnimationPlayer.play("Shake")

func attack(targets: Array) -> void:
	for target in targets:
		if is_instance_valid(target) and target.damageable and target != user:
			target.takeDamage(damage_amount)

func spawn_fire_particles(tiles: Array) -> void:
	for t in tiles:
		var pos: Vector2 = t.global_position
		var particle: Node = fire_particle_scene.instance()
		particle.global_position = pos
		GameManager.gameboard.add_child(particle)
