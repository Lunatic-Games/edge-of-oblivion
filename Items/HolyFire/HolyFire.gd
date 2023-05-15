extends "res://Items/Item.gd"

const FIRE_PARTICLES_SCENE = preload("res://Data/Particles/Fire/FireBlastParticles.tscn")

var damage_amount: int = 1
var bolt_count: int = 3
var range_radius: int = 2

# Tiers: 
#	1: 3 damage instances
#	2: 5 damage instances
#	3: 7 damage instances


func upgrade_tier() -> bool:
	var ret: bool = super.upgrade_tier()
	match current_tier:
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
	$AnimationPlayer.play("shake")


func attack(targets: Array) -> void:
	for target in targets:
		if target.damageable and target != user:
			target.take_damage(damage_amount)


func spawn_bolts(tiles: Array) -> void:
	if tiles.is_empty():
		return
	
	# Select some random tiles
	var tiles_hit: Array[Tile] = []
	var multi_hits: Array[Tile] = []
	
	for _i in range(0, bolt_count):
		var tile: Tile = tiles.pick_random()
		if tile in tiles_hit:
			multi_hits.append(tile)
		else:
			tiles_hit.append(tile)
	
	for tile in tiles_hit:
		# Rain fire
		var pos: Vector2 = tile.global_position
		var particle: Node = FIRE_PARTICLES_SCENE.instantiate()
		
		particle.global_position = pos
		GameManager.gameboard.add_child(particle)
		
		# Use alternate particle effect if tile is hit more than once
		if tile in multi_hits:
			particle.aux = true
			particle.amount -= 4
		particle.activate()
		
		# Do damage
		if tile.occupant:
			if tile.occupant.damageable:
				tile.occupant.take_damage(damage_amount)
