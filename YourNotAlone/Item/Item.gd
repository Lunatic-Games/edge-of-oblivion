extends Control

var user
var turnTimer
var maxTurnTimer
var currentTier = 0
var maxTier = 3
var item_damage = 1

onready var slashParticleScene = preload("res://SlashParticles.tscn")
onready var lightning_particle_scene = preload("res://Data/Indicators/PlayerWeaponIndicators/LightningBowIndicator.tscn")
onready var hammer_particle_scene = preload("res://Data/Indicators/PlayerWeaponIndicators/HammerIndicator.tscn")
onready var cooldown_bar = $CoolDownBar
onready var tween = $Tween
onready var sprite = $Sprite
onready var animator = $AnimationPlayer

func _ready():
	user = get_tree().get_nodes_in_group("player")[0]
	appear_unready()

func setup(data):
	sprite.texture = data.sprite
	maxTurnTimer = data.max_turn_timer
	turnTimer = maxTurnTimer
	item_damage = data.item_damage
	update_cool_down_bar()

func triggerTimer():
	turnTimer -= 1
	
	update_cool_down_bar()
	if turnTimer == 1:
		appear_ready()
	
	if turnTimer <= 0:
		turnTimer = maxTurnTimer
		update_cool_down_bar()
		appear_unready()
		yield(activateItem(), "completed")
	
	yield(get_tree(), "idle_frame")

func update_cool_down_bar():
	cooldown_bar.value = (1 - float(turnTimer-1)/float(maxTurnTimer-1)) * 100

func appear_ready():
	var goal_sprite = sprite.self_modulate
	goal_sprite.a = 1.0
	tween.interpolate_property(sprite, "self_modulate", sprite.self_modulate, goal_sprite, 0.2)
	tween.start()
	animator.play("ready")
	

func appear_unready():
	var goal_sprite = sprite.self_modulate
	goal_sprite.a = 0.4
	tween.interpolate_property(sprite, "self_modulate", sprite.self_modulate, goal_sprite, 0.2)
	animator.stop(true)
	var new_pos = sprite.position
	new_pos.y = 0
	tween.interpolate_property(sprite, "position", sprite.position, new_pos, 0.2)
	
	tween.start()

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
	var slashParticle = slashParticleScene.instance()
	slashParticle.global_position = positionToSpawn
	if positionToSpawn.x < user.currentTile.global_position.x:
		slashParticle.scale.x = slashParticle.scale.x * -1
	GameManager.gameboard.add_child(slashParticle)

func spawn_lightning_particle(position_to_spawn):
	var lightning_particle = lightning_particle_scene.instance()
	lightning_particle.global_position = position_to_spawn
	GameManager.gameboard.add_child(lightning_particle)

func spawn_hammer_indicator(position_to_spawn, should_flip):
	var hammer_particle = hammer_particle_scene.instance()
	hammer_particle.global_position = position_to_spawn
	if should_flip:
		hammer_particle.scale.y = hammer_particle.scale.y * -1
	GameManager.gameboard.add_child(hammer_particle)

func applyKnockBack(target: Occupant, direction: String, knockback: int, collideDamage: int = 0) -> bool:
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
								if applyKnockBack(occupant, direction, 1):
									new_tile = tile_to_check
								else:
									return false
							else:
								return false
						else:
							new_tile = tile_to_check
					else:
						target.fall()
						new_tile.clearOccupant()
					target.move_to_tile(new_tile)
					start_tile.clearOccupant()
	return true
