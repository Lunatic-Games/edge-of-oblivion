class_name EntityHealth
extends Object


signal value_changed(amount: int)
signal hit_zero

var entity: Entity = null
var data: HealthData = null

var current_value: int = 0


func _init(p_entity: Entity, p_data: HealthData):
	entity = p_entity
	data = p_data
	self.current_value = data.max_health


func take_damage(damage: int) -> int:
	assert(damage >= 0, "Damage should be positive")
	if damage == 0 or is_alive() == false:
		return 0
	
	var value_before: int = current_value
	current_value = maxi(current_value - damage, 0)
	
	entity.animation_player.play("damaged")
	
	var amount_changed: int = value_before - current_value
	if amount_changed > 0:
		value_changed.emit(amount_changed)
	
	if is_alive() == false:
		hit_zero.emit()
	
	return amount_changed


func heal(heal_amount: int) -> int:
	assert(heal_amount >= 0, "Heal amount should be positive")
	
	if heal_amount == 0:
		return 0
	
	var value_before: int = current_value
	current_value = mini(current_value + heal_amount, data.max_health)
	var amount_changed: int = current_value - value_before
	
	if amount_changed > 0:
		value_changed.emit(amount_changed)
	
	return amount_changed


func is_alive() -> bool:
	return current_value > 0
