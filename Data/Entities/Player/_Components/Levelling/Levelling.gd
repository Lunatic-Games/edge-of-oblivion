class_name Levelling
extends Node


signal gained_xp(amount: int)
signal levelled_up(new_level: int)

var entity: Entity = null
var data: LevellingData = null

var current_level: int = 1
var current_xp: int = 0


func _init(p_entity: Entity, p_data: LevellingData):
	entity = p_entity
	data = p_data


func gain_xp(amount: int):
	if amount == 0:
		return
	
	current_xp += amount
	gained_xp.emit(amount)
	
	var xp_to_next_level: int = get_xp_to_next_level()
	while current_xp >= xp_to_next_level:
		if xp_to_next_level == -1:
			break
		
		current_xp -= xp_to_next_level
		level_up()
		xp_to_next_level = get_xp_to_next_level()
	
	_update_experience_bar()


func level_up() -> void:
	current_level += 1
	levelled_up.emit(current_level)
	_update_experience_bar()


func get_xp_to_next_level() -> int:
	return data.get_xp_to_level(current_level + 1)


func _update_experience_bar():
	var xp_to_next_level = get_xp_to_next_level()
	var experience_bar: ExperienceBar = GlobalGameState.game.player_overlay.experience_bar
	if xp_to_next_level == -1:
		experience_bar.update(current_level, 1.0)
	else:
		experience_bar.update(current_level, float(current_xp) / float(xp_to_next_level))
