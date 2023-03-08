extends "res://Item/Item.gd"

var damage_amount: int = 1
var bolt_count: int = 3
var range_radius: int = 2

onready var fire_particle_scene = preload("res://Data/Particles/FireParticles.tscn")
# Tiers: 
#	1: 3 damage instances, 2 tile radius
#	2: 6 damage instances, 3 tile radius
#	3: 12 damage instances, 3 tile radius



func upgradeTier() -> bool:
	var ret: bool = .upgradeTier()
	match currentTier:
		2:
			bolt_count = 6
			range_radius = 3
		3:
			bolt_count = 12
	return ret

func activateItem() -> void:
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack() -> void:
	var scan_res: ItemUtil.ScanResult = ItemUtil.scan_tile_radius(user.currentTile, range_radius)
	spawn_bolts(scan_res.tiles)
	$AnimationPlayer.play("Shake")

func attack(targets: Array) -> void:
	for target in targets:
		if target.damageable and target != user:
			target.takeDamage(damage_amount)

func spawn_bolts(tiles: Array) -> void:
	# Select some random tiles
	var tiles_hit: Array = []
	for _i in range(0, bolt_count):
		tiles_hit.append(randi()%tiles.size())
	for hit in tiles_hit:
		var t: Tile = tiles[hit]
		# Rain fire
		var pos: Vector2 = t.global_position
		var particle: Node = fire_particle_scene.instance()
		particle.global_position = pos
		GameManager.gameboard.add_child(particle)
		# Do damage
		if t.occupied:
			if t.occupied.damageable:
				t.occupied.takeDamage(damage_amount)
