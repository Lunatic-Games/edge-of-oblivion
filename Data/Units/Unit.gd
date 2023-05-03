class_name Unit
extends Occupant

const DAMAGE_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/Damaged/damaged_particle2.tscn")
const HEALTH_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/Healing/HealthParticles.tscn")

var lock_movement: bool = false
var max_hp: int = 3
var canFall = true
var hp: int
var move_precedence: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite: Sprite2D = $Sprite2D
@onready var move_history: MovementUtility.MoveHistory = MovementUtility.MoveHistory.new()

@onready var particles: Dictionary = {
	"damage": DAMAGE_PARTICLES_SCENE,
	"health": HEALTH_PARTICLES_SCENE
}


func _ready() -> void:
	hp = max_hp


func setup() -> void:
	animation_player.play("spawn")
	await animation_player.animation_finished


func is_enemy() -> bool:
	return false


func take_damage(damage: int) -> int:
	assert(damage >= 0, "Damage should be positive")
	if damage == 0:
		return 0
	
	var hp_before: int = hp
	hp = maxi(hp - damage, 0)
	
	update_health_bar()
	spawn_particle("damage")
	animation_player.play("damaged")
	
	if hp == 0:
		die()
	
	return hp_before - hp


func heal(heal_amount: int) -> int:
	assert(heal_amount >= 0, "Heal amount should be positive")
	
	var hp_before: int = hp
	hp = mini(hp + heal_amount, max_hp)
	
	spawn_particle("health")
	update_health_bar()
	return hp - hp_before


func update_health_bar() -> void:
	var target_value: float = float(hp) / float(max_hp) * 100.0
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(health_bar, "value", target_value, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func spawn_particle(type: String) -> void:
	var res: PackedScene = particles[type]
	var particle: Node2D = res.instantiate()
	particle.global_position = self.global_position
	GameManager.gameboard.add_child(particle)


func die() -> void:
	current_tile.clear_occupant()
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "global_position:y", -25.0, 0.5).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	queue_free()


func fall() -> void:
	if canFall:
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
			var pushed_occupant: Unit = tile.occupant
			var last_resort_tile: Tile = current_tile
			GameManager.unoccupy_tile(last_resort_tile)
			current_tile = null
			var tile_to_displace: Tile = get_displace_tile(tile, last_resort_tile)
			pushed_occupant.move_to_tile(tile_to_displace)
		else:
			return
	
	if is_in_group("player") && tile.occupant:
		if tile.occupant.occupant_type == tile.occupant.OccupantType.COLLECTABLE:
			tile.occupant.collect()
	
	GameManager.unoccupy_tile(current_tile)
	GameManager.occupy_tile(tile, self)
	current_tile = tile
	
	lock_movement = true
	
	var base_tween: Tween = get_tree().create_tween()
	base_tween.tween_property(self, "position", tile.position, 0.20).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	var offset_tween: Tween = get_tree().create_tween()
	offset_tween.tween_property(sprite, "position:y", -15.0, 0.10).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	offset_tween.tween_property(sprite, "position:y", 15.0, 0.10).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await offset_tween.finished
	
	lock_movement = false


func get_displace_tile(displacees_tile: Tile, last_resort_tile: Tile) -> Tile:
	var possible_tiles: Array[Tile] = []
	if displacees_tile.top_tile && !displacees_tile.top_tile.occupant:
		possible_tiles.append(displacees_tile.top_tile)
	if displacees_tile.bottom_tile && !displacees_tile.bottom_tile.occupant:
		possible_tiles.append(displacees_tile.bottom_tile)
	if displacees_tile.left_tile && !displacees_tile.left_tile.occupant:
		possible_tiles.append(displacees_tile.left_tile)
	if displacees_tile.right_tile && !displacees_tile.right_tile.occupant:
		possible_tiles.append(displacees_tile.right_tile)
	
	if possible_tiles.size() > 0:
		return possible_tiles[randi()%possible_tiles.size()]
	
	return last_resort_tile
