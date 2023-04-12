extends Control

enum ChargeStyle {
	PER_TURN,
	DAMAGE_DEALT,
	DAMAGE_TAKEN
}

enum ActivationStyle {
	ON_READY,
	ON_CHARGE,
	ON_CONDITION
}

const SLASH_PARTICLES_SCENE = preload("res://Data/Particles/Attack/SlashParticles.tscn")
const LIGHTNING_PARTICLES_SCENE = preload("res://Data/Indicators/PlayerWeapons/LightningBow/LightningBowIndicator.tscn")
const HAMMER_PARTICLES_SCENE = preload("res://Data/Indicators/PlayerWeapons/Hammer/HammerIndicator.tscn")

const volatile_color = Color( 1, 0.556863, 0.34902, 1 )

var user
var turnTimer
var maxTurnTimer
var currentTier = 0
var maxTier = 3
var item_damage = 1
var charge_style = ChargeStyle.PER_TURN
var activation_style = ActivationStyle.ON_READY

@onready var cooldown_bar = $CoolDownBar
@onready var sprite = $Sprite2D
@onready var animator = $AnimationPlayer


func _ready():
	user = get_tree().get_nodes_in_group("player")[0]
	appear_unready()


func setup(data):
	sprite.texture = data.sprite
	maxTurnTimer = data.max_turn_timer
	turnTimer = maxTurnTimer
	item_damage = data.item_damage
	update_cool_down_bar()


func trigger_timer():
	if activation_style == ActivationStyle.ON_CHARGE:
		if activate_on_charge():
			await get_tree().process_frame
			return
		
		appear_ready(true)
	
	if charge_style == ChargeStyle.PER_TURN:
		turnTimer -= 1
		update_cool_down_bar()
	
	if turnTimer == 1:
		appear_ready()
		sprite.modulate = Color.WHITE
	
	if turnTimer <= 0:
		clear_timer_activate()
	
	await get_tree().process_frame


# This function is meant to be overriden by children who use ON_CHARGE activation style
func activate_on_charge() -> bool:
	return false


func clear_timer_activate():
	turnTimer = maxTurnTimer
	update_cool_down_bar()
	appear_unready()
	await activate_item()


func update_cool_down_bar():
	cooldown_bar.value = (1 - float(turnTimer-1)/float(maxTurnTimer-1)) * 100


func appear_ready(subtle: bool = false):
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "self_modulate:a", 1.0, 0.2)
	
	if subtle:
		return
	animator.play("ready")
	

func appear_unready():
	var tween = get_tree().create_tween().set_parallel()
	
	tween.tween_property(sprite, "self_modulate:a", 0.4, 0.2)
	animator.stop(true)
	
	tween.tween_property(sprite, "position:y", 32.0, 0.2)
	if activation_style == ActivationStyle.ON_CHARGE:
		sprite.modulate = volatile_color


func upgrade_tier() -> bool:
	currentTier += 1
	if currentTier >= maxTier:
		return true
	
	return false


# This func is meant to be overriden by children
func activate_item():
	print("Item not given an 'activate_item()' override.")


# returns wether or not the item should be displaying that it's activatable
func is_ready_to_use():
	if turnTimer == 1:
		return true
	return false


func spawn_slash_particle(position_to_spawn):
	var slashParticle = SLASH_PARTICLES_SCENE.instantiate()
	
	slashParticle.global_position = position_to_spawn
	if position_to_spawn.x < user.current_tile.global_position.x:
		slashParticle.scale.x = slashParticle.scale.x * -1
	GameManager.gameboard.add_child(slashParticle)


func spawn_lightning_particle(position_to_spawn):
	var lightning_particle = LIGHTNING_PARTICLES_SCENE.instantiate()
	
	lightning_particle.global_position = position_to_spawn
	GameManager.gameboard.add_child(lightning_particle)


func spawn_hammer_indicator(position_to_spawn, should_flip):
	var hammer_particle = HAMMER_PARTICLES_SCENE.instantiate()
	
	hammer_particle.global_position = position_to_spawn
	if should_flip:
		hammer_particle.scale.y = hammer_particle.scale.y * -1
	GameManager.gameboard.add_child(hammer_particle)


func apply_knockback(target: Occupant, direction: String, knockback: int, collideDamage: int = 0) -> bool:
	var start_tile: Tile = target.current_tile
	if target.is_alive():
		var directions: Dictionary = {"up": start_tile.top_tile, "down": start_tile.bottom_tile, "left": start_tile.left_tile, "right": start_tile.right_tile}
		for dir in directions.keys():
			if direction == dir:
				for x in knockback:
					var new_tile: Tile = target.current_tile
					var occupant: Occupant = null
					var tile_to_check: Tile = directions[dir]
					if tile_to_check:
						occupant = tile_to_check.occupant
						if occupant:
							target.take_damage(collideDamage)
							if occupant.damageable:
								occupant.take_damage(collideDamage)
							if occupant.pushable:
								if apply_knockback(occupant, direction, 1):
									new_tile = tile_to_check
								else:
									return false
							else:
								return false
						else:
							new_tile = tile_to_check
					else:
						target.fall()
						new_tile.clear_occupant()
					target.move_to_tile(new_tile)
					start_tile.clear_occupant()
	return true
