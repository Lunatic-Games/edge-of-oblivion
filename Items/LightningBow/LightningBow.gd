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
		if tile.occupied && tile.occupied.is_enemy():
			targets.append(tile)
	
	if remaining_chains > 0:
		var newTarget = tile.getRandomEnemyOccupiedAdjacentTile()
		remaining_chains -= 1
		if newTarget:
			build_target_list(newTarget)
	
	if remaining_chains <= 0:
		remaining_chains = chains

func attack():
	for target in targets:
		spawn_lightning_particle(target.global_position)
		if is_instance_valid(target.occupied) && target.occupied.is_enemy():
			target.occupied.take_damage(item_damage)
		await get_tree().create_timer(0.2).timeout


func upgrade_tier() -> bool:
	currentTier += 1
	
	if currentTier == 2:
		chains = 2
		remaining_chains = 2
	
	if currentTier == 3:
		chains = 4
		remaining_chains = 4
	
	if currentTier >= maxTier:
		return true
	
	return false
