extends "res://Items/Item.gd"

const FIRE_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/Fire/FireParticles.tscn")

var damage_amount: int = 1
var max_blast_amount: int = 2
var max_blast: bool = false
var charges: int = 0

# Tiers: 
#	1: 3 max charges
#	2: 4 max charges
#	3: 5 max charges


func _ready() -> void:
#	activation_style = ActivationStyle.ON_CHARGE
	super._ready()


# Returns true if item activated
func activate_on_charge() -> bool:
	# Roll chance
#	if turn_timer == 1:
#		max_blast = true
#	charges = max_turn_timer - turn_timer
#	var chance_to_activate: float = float(max_turn_timer - turn_timer) / max_turn_timer
#	var roll = randf()
#	if roll < chance_to_activate:
#		clear_timer_activate()
#		return true
	return false


func upgrade_tier() -> void:
	super.upgrade_tier()
#	match current_tier:
#		2:
#			max_turn_timer = 4
#		3:
#			max_turn_timer = 5
#	update_cool_down_bar()


func activate_item() -> void:
	perform_attack()
	await get_tree().process_frame


func perform_attack() -> void:
	pass
#	var last_direction: Vector2i = user.move_history.get_record(0).direction
#	var scan_res: ItemUtil.ScanResult = null
#	if max_blast:
#		scan_res = ItemUtil.scan_in_direction(user.current_tile, last_direction, charges)
#	else:
#		scan_res = ItemUtil.scan_in_direction(user.current_tile, last_direction, 1)
#
#	var tiles: Array[Tile] = scan_res.tiles
#	spawn_fire_particles(tiles)
#	attack(tiles)
#	if not max_blast and current_tier >= 3:
#		turn_timer -= 1
#		update_cool_down_bar()
	
	max_blast = false
	charges = 0
	$AnimationPlayer.play("shake")


func attack(tiles: Array[Tile]) -> void:
	for t in tiles:
		var occupant: Occupant = t.occupant
		if occupant:
			if occupant.damageable:
				if max_blast:
					occupant.take_damage(max_blast_amount)
				else:
					occupant.take_damage(damage_amount)


func spawn_fire_particles(tiles: Array) -> void:
	for t in tiles:
		var pos: Vector2 = t.global_position
		var particle: Node = FIRE_PARTICLES_SCENE.instantiate()
		particle.global_position = pos
		GameManager.gameboard.add_child(particle)
	
