extends "res://Items/Item.gd"

# Tiers
# 1 - Shoot range 1 up, attacks chain 1 for 1 damage
# 2 - Attack chains 2
# 3 - Attack chains 4

var targets = []
var chains = 1
@onready var remaining_chains = chains

func activate_item():
	targets = []
	performAttack()
	await get_tree().process_frame

func performAttack():
	var targetTile
	
	var oneTileUp = user.current_tile.top_tile
	if !oneTileUp:
		return
	
	var twoTilesUp = oneTileUp.top_tile
	if twoTilesUp:
		targetTile = twoTilesUp
	else:
		targetTile = oneTileUp
	
	$AnimationPlayer.play("Shake")
	
	build_target_list(targetTile, true)
	attack()


func build_target_list(tile, is_entry_point = false):
	if is_entry_point:
		if tile:
			targets.append(tile)
	else:
		if tile.occupant && tile.occupant.is_enemy():
			targets.append(tile)
	
	if remaining_chains > 0:
		var newTarget = tile.get_random_enemy_occupied_adjacent_tile()
		remaining_chains -= 1
		if newTarget:
			build_target_list(newTarget)
	
	if remaining_chains <= 0:
		remaining_chains = chains

func attack():
	for target in targets:
		spawn_lightning_particle(target.global_position)
		if is_instance_valid(target.occupant) && target.occupant.is_enemy():
			target.occupant.take_damage(item_damage)
		await get_tree().create_timer(0.2).timeout


func upgrade_tier() -> bool:
	current_tier += 1
	
	if current_tier == 2:
		chains = 2
		remaining_chains = 2
	
	if current_tier == 3:
		chains = 4
		remaining_chains = 4
	
	if current_tier >= maxTier:
		return true
	
	return false
