extends "res://Items/Item.gd"

const FIRE_PARTICLES_SCENE = preload("res://Data/Particles/Fire/FireParticles2.tscn")

var damage_amount: int = 1
var bolt_count: int = 3
var range_radius: int = 2

# Tiers: 
#	1: 3 damage instances
#	2: 5 damage instances
#	3: 7 damage instances


func upgrade_tier() -> bool:
	var ret: bool = super.upgrade_tier()
	match currentTier:
		2:
			bolt_count = 5
		3:
			bolt_count = 7
	return ret

func activate_item() -> void:
	perform_attack()
	await get_tree().process_frame

func perform_attack() -> void:
	var scan_res: ItemUtil.ScanResult = ItemUtil.scan_tile_radius(user.current_tile, range_radius)
	spawn_bolts(scan_res.tiles)
	$AnimationPlayer.play("Shake")

func attack(targets: Array) -> void:
	for target in targets:
		if target.damageable and target != user:
			target.take_damage(damage_amount)

func spawn_bolts(tiles: Array) -> void:
	# Select some random tiles
	var tiles_hit: Array = []
	var double_hits: Array = []
	
	for _i in range(0, bolt_count):
		var index: int = randi()%tiles.size()
		if index in tiles_hit:
			double_hits.append(index)
		else:
			tiles_hit.append(index)
	
	for hit in tiles_hit:
		var t: Tile = tiles[hit]
		# Rain fire
		var pos: Vector2 = t.global_position
		var particle: Node = FIRE_PARTICLES_SCENE.instantiate()
		
		particle.global_position = pos
		GameManager.gameboard.add_child(particle)
		
		# Use alternate particle effect if tile is hit more than once
		if hit in double_hits:
			particle.aux = true
			particle.amount -= 4
		particle.activate()
		
		# Do damage
		if t.occupant:
			if t.occupant.damageable:
				t.occupant.take_damage(damage_amount)
