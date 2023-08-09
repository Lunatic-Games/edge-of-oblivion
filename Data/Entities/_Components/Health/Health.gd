class_name EntityHealth
extends Object


signal value_changed(amount: int)
signal died

const HEAL_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/Health/HealParticles.tscn")
const DAMAGED_PARTICLES_SCENE: PackedScene = preload("res://Data/Particles/Health/DamagedParticles.tscn")

var entity: Entity = null
var data: HealthData = null

var current_value: int = 0


func _init(p_entity: Entity, p_data: HealthData):
	entity = p_entity
	data = p_data
	self.current_value = data.max_health


func take_damage(damage: int) -> int:
	assert(damage >= 0, "Damage should be positive")
	if damage == 0 or is_alive() == false or data.can_be_damaged == false:
		return 0
	
	var value_before: int = current_value
	if data.can_be_killed:
		current_value = maxi(current_value - damage, 0)
	else:
		current_value = maxi(current_value - damage, 1)
	
	entity.animator.play("damaged")
	if data.emit_particles_on_taking_damage:
		_spawn_particles(DAMAGED_PARTICLES_SCENE)
	
	var amount_changed: int = value_before - current_value
	if amount_changed > 0:
		_update_health_bar()
		value_changed.emit(amount_changed)
	
	if is_alive() == false:
		_die()
	
	return amount_changed


func heal(heal_amount: int) -> int:
	assert(heal_amount >= 0, "Heal amount should be positive")
	
	if heal_amount == 0 or is_alive() == false or data.can_be_healed == false:
		return 0
	
	var value_before: int = current_value
	current_value = mini(current_value + heal_amount, data.max_health)
	
	if data.emit_particles_on_heal:
		_spawn_particles(HEAL_PARTICLES_SCENE)
	
	var amount_changed: int = current_value - value_before
	
	if amount_changed > 0:
		_update_health_bar()
		value_changed.emit(amount_changed)
	
	return amount_changed


func full_heal() -> int:
	return heal(data.max_health)


func deal_lethal_damage() -> int:
	return take_damage(current_value)


func is_alive() -> bool:
	return current_value > 0


func _die() -> void:
	if entity.occupancy and entity.occupancy.current_tile:
		entity.occupancy.current_tile.occupant = null
	
	died.emit()
	
	var tween: Tween = entity.create_tween().set_parallel(true)
	tween.tween_property(entity.sprite, "position:y", -25.0, 0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(entity, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	entity.queue_free()


func _spawn_particles(particles_scene: PackedScene) -> void:
	var particle: Node2D = particles_scene.instantiate()
	particle.global_position = entity.global_position
	
	var board: Board = GlobalGameState.get_board()
	board.add_child(particle)


func _update_health_bar() -> void:
	var target_value: float = float(current_value) / float(data.max_health) * 100.0
	
	var tween: Tween = entity.create_tween()
	tween.tween_property(entity.health_bar, "value", target_value, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
