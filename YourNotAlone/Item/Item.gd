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
		yield(activateItem(), "completed")
		end_blink()
		turnTimer = maxTurnTimer
		update_cool_down_bar()
	
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

func start_blink():
	#blink_tween.interpolate_property($Sprite, "material/shader_param/line_thickness", 0.0, 7.0, 0.6)
	#blink_tween.start()
	pass

func end_blink():
	#blink_tween.interpolate_property($Sprite, "material/shader_param/line_thickness", 7.0, 0.0, 0.6)
	#blink_tween.start()
	pass


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

func applyKnockBack(occupant, direction, knockback, collideDamage=0):
	var new_tile = occupant.currentTile
	if occupant.is_alive():
		if direction == "up":
			for x in knockback:
				var tile_to_check = new_tile.topTile
				if tile_to_check and tile_to_check.occupied:
					# Then do damage to both the currrent enemy and the unit on this tile
					pass
				elif tile_to_check:
					new_tile = tile_to_check
		# Do check for left and right; bring complexity away from item implementation
		elif direction == "down":
			for x in knockback:
				var tile_to_check = new_tile.bottomTile
				if tile_to_check and tile_to_check.occupied:
					# Then do damage to both the currrent enemy and the unit on this tile
					pass
				elif tile_to_check:
					new_tile = tile_to_check
	
		occupant.moveToTile(new_tile)
