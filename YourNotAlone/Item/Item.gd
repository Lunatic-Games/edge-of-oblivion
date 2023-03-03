extends Control

var user
var turnTimer
var maxTurnTimer
var currentTier = 0
var maxTier = 3
var item_damage = 1

onready var slashParticleScene = preload("res://SlashParticles.tscn")
onready var cooldown_bar = $CoolDownBar
onready var blink_tween = $BlinkTween

func _ready():
	user = get_tree().get_nodes_in_group("player")[0]

func setup(data):
	$Sprite.texture = data.sprite
	maxTurnTimer = data.max_turn_timer
	turnTimer = maxTurnTimer
	item_damage = data.item_damage
	update_cool_down_bar()

func triggerTimer():
	turnTimer -= 1
	
	update_cool_down_bar()
	
	if turnTimer <= 0:
		turnTimer = maxTurnTimer
		update_cool_down_bar()
		yield(activateItem(), "completed")
	
	yield(get_tree(), "idle_frame")

func update_cool_down_bar():
	cooldown_bar.value = (1 - float(turnTimer-1)/float(maxTurnTimer-1)) * 100

func upgradeTier() -> bool:
	currentTier += 1
	if currentTier >= maxTier:
		return true
	
	return false

func activateItem():
	pass

# returns wether or not the item should be displaying that it's activatable
func is_ready_to_use():
	if turnTimer == 1:
		return true
	return false

func spawnSlashParticle(positionToSpawn):
	# Spawn attack slash
	var slashParticle = slashParticleScene.instance()
	slashParticle.position = user.currentTile.position
	if positionToSpawn.position < user.position:
		slashParticle.scale.x = slashParticle.scale.x * -1
	slashParticle.emitting = true
	get_tree().root.add_child(slashParticle)

func spawnLightningParticle(positionToSpawn):
	# Spawn attack slash
	var slashParticle = slashParticleScene.instance()
	slashParticle.position = positionToSpawn.position
	slashParticle.emitting = true
	get_tree().root.add_child(slashParticle)

func applyKnockBack(target: Occupant, direction: String, knockback: int, collideDamage: int = 0) -> void:
	var start_tile: Tile = target.currentTile
	if target.is_alive():
		var directions: Dictionary = {"up": start_tile.topTile, "down": start_tile.bottomTile, "left": start_tile.leftTile, "right": start_tile.rightTile}
		for dir in directions.keys():
			if direction == dir:
				for x in knockback:
					var new_tile: Tile = target.currentTile
					var occupant: Occupant = null
					var tile_to_check: Tile = directions[dir]
					if tile_to_check:
						occupant = tile_to_check.occupied
						if occupant:
							target.takeDamage(collideDamage)
							if occupant.damageable:
								occupant.takeDamage(collideDamage)
							if occupant.pushable:
								applyKnockBack(occupant, direction, 1)
								
								new_tile = tile_to_check
						else:
							new_tile = tile_to_check
					else:
						target.fall()
						new_tile.clearOccupant()
					target.moveToTile(new_tile)
					start_tile.clearOccupant()
