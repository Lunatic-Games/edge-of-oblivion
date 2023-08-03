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
	if damage == 0 or is_alive() == false or data.can_be_damaged == false:
		return 0
	
	var value_before: int = current_value
	if data.can_be_killed:
		current_value = maxi(current_value - damage, 0)
	else:
		current_value = maxi(current_value - damage, 1)
	
	entity.animator.play("damaged")
	
	var amount_changed: int = value_before - current_value
	if amount_changed > 0:
		update_health_bar()
		value_changed.emit(amount_changed)
	
	if is_alive() == false:
		hit_zero.emit()
	
	return amount_changed


func heal(heal_amount: int) -> int:
	assert(heal_amount >= 0, "Heal amount should be positive")
	
	if heal_amount == 0 or is_alive() == false or data.can_be_healed == false:
		return 0
	
	var value_before: int = current_value
	current_value = mini(current_value + heal_amount, data.max_health)
	var amount_changed: int = current_value - value_before
	
	if amount_changed > 0:
		update_health_bar()
		value_changed.emit(amount_changed)
	
	return amount_changed


func full_heal() -> int:
	return heal(data.max_health - current_value)


func deal_lethal_damage() -> int:
	return take_damage(current_value)


func is_alive() -> bool:
	return current_value > 0


func update_health_bar() -> void:
	var target_value: float = float(current_value) / float(data.max_health) * 100.0
	
	var tween: Tween = entity.create_tween()
	tween.tween_property(entity.health_bar, "value", target_value, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
