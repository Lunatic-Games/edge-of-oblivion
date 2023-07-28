class_name Unit
extends Occupant

signal health_changed
signal died

const DAMAGE_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/Health/DamagedParticles.tscn")
const HEALTH_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/Health/HealParticles.tscn")

@export var max_hp: int = 50
@export var move_precedence: float = 0.0
@export var can_fall: bool = true

var lock_movement: bool = false

@onready var hp: int = max_hp

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite: Sprite2D = $Sprite2D


func play_spawn_animation() -> void:
	animation_player.play("spawn")


func take_damage(damage: int) -> int:
	assert(damage >= 0, "Damage should be positive")
	if damage == 0:
		return 0
	
	var hp_before: int = hp
	hp = maxi(hp - damage, 0)
	
	update_health_bar()
	spawn_particle(DAMAGE_PARTICLES_SCENE, true)
	animation_player.play("damaged")
	
	if hp != hp_before:
		health_changed.emit()
	
	if hp == 0:
		die()
	
	return hp_before - hp


func heal(heal_amount: int) -> int:
	assert(heal_amount >= 0, "Heal amount should be positive")
	
	if heal_amount == 0:
		return 0
	
	var hp_before: int = hp
	hp = mini(hp + heal_amount, max_hp)
	
	spawn_particle(HEALTH_PARTICLES_SCENE, true)
	update_health_bar()
	
	if hp != hp_before:
		health_changed.emit()
	
	return hp - hp_before


func update_health_bar() -> void:
	var target_value: float = float(hp) / float(max_hp) * 100.0
	
	var tween: Tween = create_tween()
	tween.tween_property(health_bar, "value", target_value, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func spawn_particle(particles_scene: PackedScene, use_tile_position: bool = false) -> void:
	var particle: Node2D = particles_scene.instantiate()
	if use_tile_position and current_tile != null:
		particle.global_position = current_tile.global_position
	else:
		particle.global_position = self.global_position
	GlobalGameState.board.add_child(particle)


func die() -> void:
	current_tile.occupant = null
	died.emit()
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position:y", -25.0, 0.5).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	queue_free()


func fall() -> void:
	if can_fall:
		die()
	else:
		# Handle cases like bosses where unit can't fall
		pass


func is_alive() -> bool:
	if hp > 0:
		return true
	return false


func move_to_tile(tile) -> void:
	if tile.occupant && tile.occupant.occupant_type == tile.occupant.OccupantType.BLOCKING:
		if move_precedence > tile.occupant.move_precedence:
			var current_tile_occupant: Unit = tile.occupant
			var tile_to_displace_to: Tile = get_displace_tile(tile)
			if tile_to_displace_to == null:
				return
			
			current_tile_occupant.move_to_tile(tile_to_displace_to)
		else:
			return
	
	var collectable = null

	if tile.occupant and tile.occupant.occupant_type == tile.occupant.OccupantType.COLLECTABLE:
		collectable = tile.occupant
	
	current_tile.occupant = null
	
	current_tile = tile
	current_tile.occupant = self
	
	lock_movement = true
	
	if collectable:
		collectable.collect()
	
	var base_tween: Tween = create_tween()
	base_tween.tween_property(self, "position", tile.position, 0.20).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	var offset_tween: Tween = create_tween()
	offset_tween.tween_property(sprite, "position:y", -15.0, 0.10).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	offset_tween.tween_property(sprite, "position:y", 15.0, 0.10).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await offset_tween.finished
	
	lock_movement = false


func get_displace_tile(base_tile: Tile) -> Tile:
	var possible_tiles: Array[Tile] = []
	if base_tile.top_tile && !base_tile.top_tile.occupant:
		possible_tiles.append(base_tile.top_tile)
	if base_tile.bottom_tile && !base_tile.bottom_tile.occupant:
		possible_tiles.append(base_tile.bottom_tile)
	if base_tile.left_tile && !base_tile.left_tile.occupant:
		possible_tiles.append(base_tile.left_tile)
	if base_tile.right_tile && !base_tile.right_tile.occupant:
		possible_tiles.append(base_tile.right_tile)
	
	if possible_tiles.size() > 0:
		return possible_tiles.pick_random()
	
	return null
