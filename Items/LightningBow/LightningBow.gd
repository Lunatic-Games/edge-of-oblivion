extends "res://Items/Item.gd"

# Tiers
# 1 - Shoot range 1 up, attacks chain 1 for 1 damage
# 2 - Attack chains 2
# 3 - Attack chains 4

var targets: Array[Tile] = []
var chains: int = 1

@onready var remaining_chains: int = chains


func activate_item() -> void:
	targets = []
	perform_attack()
	await get_tree().process_frame


func perform_attack() -> void:
	var target_tile: Tile
	
	var one_tile_up: Tile = user.current_tile.top_tile
	if !one_tile_up:
		return
	
	var two_tiles_up: Tile = one_tile_up.top_tile
	if two_tiles_up:
		target_tile = two_tiles_up
	else:
		target_tile = one_tile_up
	
	animator.play("Shake")
	
	build_target_list(target_tile, true)
	attack()


func build_target_list(tile: Tile, is_entry_point = false) -> void:
	if is_entry_point:
		if tile:
			targets.append(tile)
	else:
		if tile.occupant && tile.occupant.is_enemy():
			targets.append(tile)
	
	if remaining_chains > 0:
		var new_target: Tile = tile.get_random_enemy_occupied_adjacent_tile()
		remaining_chains -= 1
		if new_target:
			build_target_list(new_target)
	
	if remaining_chains <= 0:
		remaining_chains = chains

func attack() -> void:
	pass
#	for target in targets:
#		spawn_lightning_particle(target.global_position)
#		if is_instance_valid(target.occupant) && target.occupant.is_enemy():
#			target.occupant.take_damage(item_damage)
#		await get_tree().create_timer(0.2).timeout


func upgrade_tier() -> void:
	super.upgrade_tier()
	
	if current_tier == 2:
		chains = 2
		remaining_chains = 2
	
	if current_tier == 3:
		chains = 4
		remaining_chains = 4
