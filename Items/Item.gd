class_name Item
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

const SLASH_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/Attack/SlashParticles.tscn")
const LIGHTNING_PARTICLES_SCENE: PackedScene = preload("res://Data/Indicators/PlayerWeapons/LightningBow/LightningBowIndicator.tscn")
const HAMMER_PARTICLES_SCENE: PackedScene = preload("res://Data/Indicators/PlayerWeapons/Hammer/HammerIndicator.tscn")

const VOLATILE_COLOR: Color = Color( 1, 0.556863, 0.34902, 1 )

var user: Unit
var turn_timer
var max_turn_timer
var current_tier = 0
var max_tier = 3
var item_damage = 1
var charge_style = ChargeStyle.PER_TURN
var activation_style = ActivationStyle.ON_READY

@onready var cooldown_bar: ProgressBar = $CoolDownBar
@onready var texture_rect: TextureRect = $Texture
@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	user = get_tree().get_nodes_in_group("player")[0]
	appear_unready()


func setup(data) -> void:
	texture_rect.texture = data.sprite
	max_turn_timer = data.max_turn_timer
	turn_timer = max_turn_timer
	item_damage = data.item_damage
	update_cool_down_bar()


func trigger_timer() -> void:
	if activation_style == ActivationStyle.ON_CHARGE:
		if activate_on_charge():
			await get_tree().process_frame
			return
		
		appear_ready(true)
	
	if charge_style == ChargeStyle.PER_TURN:
		turn_timer -= 1
		update_cool_down_bar()
	
	if turn_timer == 1:
		appear_ready()
		texture_rect.modulate = Color.WHITE
	
	if turn_timer <= 0:
		clear_timer_activate()
	
	await get_tree().process_frame


# This function is meant to be overriden by children who use ON_CHARGE activation style
func activate_on_charge() -> bool:
	return false


func clear_timer_activate() -> void:
	turn_timer = max_turn_timer
	update_cool_down_bar()
	appear_unready()
	await activate_item()


func update_cool_down_bar() -> void:
	cooldown_bar.value = (1 - float(turn_timer-1)/float(max_turn_timer-1)) * 100


func appear_ready(subtle: bool = false) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(texture_rect, "self_modulate:a", 1.0, 0.2)
	
	if subtle:
		return
	animator.play("ready")
	

func appear_unready() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel()
	
	tween.tween_property(texture_rect, "self_modulate:a", 0.4, 0.2)
	animator.stop(true)
	
	tween.tween_property(texture_rect, "position:y", 0.0, 0.2)
	if activation_style == ActivationStyle.ON_CHARGE:
		texture_rect.modulate = VOLATILE_COLOR


func upgrade_tier() -> bool:
	current_tier += 1
	if current_tier >= max_tier:
		return true
	
	return false


# This func is meant to be overriden by children
func activate_item() -> void:
	print("Item not given an 'activate_item()' override.")
	await get_tree().process_frame


# returns wether or not the item should be displaying that it's activatable
func is_ready_to_use() -> bool:
	return (turn_timer == 1)


func spawn_slash_particle(position_to_spawn) -> void:
	var slash_particle: Node2D = SLASH_PARTICLES_SCENE.instantiate()
	
	slash_particle.global_position = position_to_spawn
	if position_to_spawn.x < user.current_tile.global_position.x:
		slash_particle.scale.x = slash_particle.scale.x * -1
	GameManager.gameboard.add_child(slash_particle)


func spawn_lightning_particle(position_to_spawn) -> void:
	var lightning_particle: Node2D = LIGHTNING_PARTICLES_SCENE.instantiate()
	
	lightning_particle.global_position = position_to_spawn
	GameManager.gameboard.add_child(lightning_particle)


func spawn_hammer_indicator(position_to_spawn, should_flip) -> void:
	var hammer_particle: Node2D = HAMMER_PARTICLES_SCENE.instantiate()
	
	hammer_particle.global_position = position_to_spawn
	if should_flip:
		hammer_particle.scale.y = hammer_particle.scale.y * -1
	GameManager.gameboard.add_child(hammer_particle)


# Returns true if the target was successfully knocked back a tile
func apply_knockback(target: Occupant, direction: Vector2i, knockback: int, collideDamage: int = 0) -> bool:
	if not target.is_alive() or knockback == 0:
		return true
		
	var start_tile: Tile = target.current_tile
	var next_tile: Tile = start_tile.get_tile_in_direction(direction)
	
	if next_tile:
		var next_tile_occupant: Occupant = next_tile.occupant
		
		# Try pushing into next occupant if there is one
		if next_tile_occupant:
			if target.damageable:
				target.take_damage(collideDamage)
			if next_tile_occupant.damageable:
				next_tile_occupant.take_damage(collideDamage)
			
			if next_tile_occupant.pushable:
				if apply_knockback(next_tile_occupant, direction, 1):
					target.move_to_tile(next_tile)
					start_tile.clear_occupant()
					return true
				else:
					return false
			else:
				return false
		
		# No next occupant, can just move
		else:
			target.move_to_tile(next_tile)
			start_tile.clear_occupant()
	
	# Fall off end of map
	else:
		target.fall()
		start_tile.clear_occupant()
	
	return true
